#include <stdlib.h>
#include <stdio.h>

#define FUZZY_POINTS 1000
#include "../include/edo_fuzzy_solver/solver.cuh"

int main(int argc, const char * argv[]) {
    unsigned int i;
    double * fuzzy_set, end_point, start_point;
    edo_fuzzy_solver local_solver;
    edo_fuzzy_solver_error error_t;
    edo_fuzzy_solution solution = {0, 0, 0};

    // EXAMPLE 15
    fuzzy_set = (double*)malloc(sizeof(double) * FUZZY_POINTS);
    start_point = 0;
    end_point   = 2;
    
    for (i = 0; i < FUZZY_POINTS - 1;i++) {
        fuzzy_set[i] = start_point + (end_point * i) / FUZZY_POINTS;
    }

    double tol = 0.00001;
    int size = 1/tol;
    fuzzy_set[i] = end_point;
    error_t = edo_fuzzy_solver_create(fuzzy_set, FUZZY_POINTS, tol , &local_solver);

    if (error_t != EFS_E_OK) {
        printf("ERROR #%d\n", error_t);
        return 1;
    }

    error_t = edo_fuzzy_solver_solve(local_solver, &solution);

    if (error_t != EFS_E_OK) {
        printf("ERROR #%d\n", error_t);
        return 1;
    }

    for (i = 0; i < solution.points;i++) {
        printf("f(%lf)=%lf\n", solution.x_values[i][size - 1], solution.y_values[i][size - 1]);
    }
    return 0;
}
