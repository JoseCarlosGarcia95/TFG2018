#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "../../include/edo_fuzzy_solver/solver.cuh"
#include "../../include/utils/cuda.cuh"

__device__ double edo_fuzzy_solver_device_function_call(double x, double y) {
    return exp(-y * y);
}

__device__ unsigned long edo_fuzzy_solver_calculate_pointer(long i, long j, long n) {
    return i * (n+1) + j;
}

edo_fuzzy_solver_error edo_fuzzy_solver_create(double * fuzzy_set, unsigned int fuzzy_set_length, double tol, edo_fuzzy_solver* solver) {
    edo_fuzzy_solver_error error_t;

    error_t                  = EFS_E_OK;

    solver->fuzzy_set        = fuzzy_set;
    solver->fuzzy_set_length = fuzzy_set_length;
    solver->tol              = tol;

    return error_t;
}


__global__ void edo_fuzzy_solver_kernel_runge_kutta(double * fuzzy_set, double tol, unsigned int n, unsigned int fuzzy_set_length, double* x_values, double* y_values) {
    unsigned long i, j, pointer;
    double k1, k2, k3, k4, x, y;
    
    i = threadIdx.x + blockIdx.x * blockDim.x;

    if (i >= fuzzy_set_length) {
        return;
    }

    // Initial value.
    
    pointer           = edo_fuzzy_solver_calculate_pointer(i, 0, fuzzy_set_length);
    y_values[pointer] = fuzzy_set[i];

    for (j = 0; j < n; j++) {
        pointer           = edo_fuzzy_solver_calculate_pointer(i, j, fuzzy_set_length);

        x_values[pointer] = j * tol;

        x                 = x_values[pointer];
        y                 = y_values[pointer];
        k1                = edo_fuzzy_solver_device_function_call(x, y);

        x                 = x_values[pointer] + .5 * tol;
        y                 = y_values[pointer] + .5 * tol * k1;
        k2                = edo_fuzzy_solver_device_function_call(x, y);

        x                 = x_values[pointer] + .5 * tol;
        y                 = y_values[pointer] + .5 * tol * k2;
        k3                = edo_fuzzy_solver_device_function_call(x, y);

        x                 = x_values[pointer] + tol;
        y                 = y_values[pointer] + tol * k3;
        k4                = edo_fuzzy_solver_device_function_call(x, y);

        y_values[pointer + 1] = y_values[pointer] + tol/6 * (k1 + 2*k2 + 2*k3 + k4);
    }
}

edo_fuzzy_solver_error edo_fuzzy_solver_solve(edo_fuzzy_solver solver, edo_fuzzy_solution * solution) {
    int gridSize, blockSize, minGridSize;
    unsigned long n, i, j;
    edo_fuzzy_solver_error error_t;
    cudaError_t cuda_error;
    double* fuzzy_set_cuda, *x_values_cuda, *y_values_cuda, *x_values_raw, *y_values_raw;
    
    error_t = EFS_E_OK;
    n = 1.0/solver.tol;

    // Starts cuda.
    cuda_error = cudaSetDevice(0);

    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    // Allocate cuda memory.
    cuda_error = cudaMalloc(&fuzzy_set_cuda, sizeof(double) * solver.fuzzy_set_length);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    // Copy host memory to GPU.
    cuda_error = cudaMemcpy(fuzzy_set_cuda, solver.fuzzy_set, solver.fuzzy_set_length * sizeof(double), cudaMemcpyHostToDevice);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    cuda_error = cudaMalloc(&x_values_cuda, sizeof(double) * solver.fuzzy_set_length * n);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    cuda_error = cudaMalloc(&y_values_cuda, sizeof(double) * solver.fuzzy_set_length * n);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    cudaOccupancyMaxPotentialBlockSize(&minGridSize, &blockSize, edo_fuzzy_solver_kernel_runge_kutta, 0, solver.fuzzy_set_length);
    gridSize = (solver.fuzzy_set_length + blockSize - 1) / blockSize;

    // Run runge kutta in kernel.    
    edo_fuzzy_solver_kernel_runge_kutta << <gridSize, blockSize >> >(fuzzy_set_cuda, solver.tol, n, solver.fuzzy_set_length, x_values_cuda, y_values_cuda);

    cuda_error = cudaDeviceSynchronize();
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    // Now pass the result to CPU.
    x_values_raw = (double*)malloc(sizeof(double) * solver.fuzzy_set_length * n);
    y_values_raw = (double*)malloc(sizeof(double) * solver.fuzzy_set_length * n);

    cuda_error = cudaMemcpy(x_values_raw, x_values_cuda, solver.fuzzy_set_length * sizeof(double) * n, cudaMemcpyDeviceToHost);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    cuda_error = cudaMemcpy(y_values_raw, y_values_cuda, solver.fuzzy_set_length * sizeof(double) * n, cudaMemcpyDeviceToHost);
    if (cuda_error != cudaSuccess) {
        error_t = EFS_E_CUDA_ERROR;
        goto clean;
    }

    solution->x_values = (double**)realloc(solution->x_values, sizeof(double*) * solver.fuzzy_set_length);
    solution->y_values = (double**)realloc(solution->y_values, sizeof(double*) * solver.fuzzy_set_length);
    
    for (i = 0; i < solver.fuzzy_set_length;i++) {
        solution->x_values[i] = (double*)malloc(sizeof(double) * n);
        solution->y_values[i] = (double*)malloc(sizeof(double) * n);

        for (j = 0; j < n; j++) {
            solution->x_values[i][j] = x_values_raw[i * (solver.fuzzy_set_length + 1) + j];
            solution->y_values[i][j] = y_values_raw[i * (solver.fuzzy_set_length + 1) + j];
        }
    }

    solution->points = n;
 clean:
    if (!fuzzy_set_cuda) {
        cudaFree(fuzzy_set_cuda);
    }
    
    if (!x_values_cuda) {
        cudaFree(x_values_cuda);
    }

    if (!x_values_cuda) {
        cudaFree(x_values_cuda);
    }

    if (!x_values_raw) {
        free(x_values_raw);
    }

    if (!y_values_raw) {
        free(y_values_raw);
    }
    
    if (cuda_error != cudaSuccess) {
        fprintf(stderr,"CUDA assert: %s\n", cudaGetErrorString(cuda_error));
    }
    return error_t;
}

double edo_fuzzy_solver_evaluate(double x, unsigned int fuzzy_value, edo_fuzzy_solution* solution) {
    return NAN; 
}
