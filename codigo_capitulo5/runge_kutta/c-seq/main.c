#include <stdio.h>
#include <stdlib.h>

#include "math.h"

/**
 * For testing speed with different preccision.
 */
#ifdef DOUBLE_PRECCISION
    typedef double num;
#else
    typedef float  num; 
#endif

/**
 * EDO to solve.
 */
num function_problem(num x, num y) {
    return 2*x - 3*y + 1;
}

/**
 * EDO solution.
 */
num function_solution(num x, num ai) {
    return (exp(-3*x) * (-1 + ai * 9 + exp(3*x) * (1 + 6*x))) / 9;
}

int main(int argc, char const *argv[])
{
    unsigned int fuzzy_partition_size, euler_step_size, i, j;
    num *fuzzy_partitions, *x_domain, yi0, yij, max_error, h, k1, k2, k3, k4;

    // Configuration
    fuzzy_partition_size = atoi(argv[1]);
    euler_step_size      = atoi(argv[2]); 

    // Declare problem variables.
    fuzzy_partitions     = malloc(sizeof(num) * fuzzy_partition_size);
    x_domain             = malloc(sizeof(num) * euler_step_size);
    
    for (i = 0; i  < fuzzy_partition_size; i++) {
        fuzzy_partitions[i] = -1 + 2.0*i / (fuzzy_partition_size - 1);
    }

    for (i = 0;i < euler_step_size; i++) {
        x_domain[i] = 1.0 * i / (euler_step_size - 1);
    }

    h = 1.0 / (euler_step_size - 1);
    max_error = 0;
    
    // Solve it.
    for (i = 0; i < fuzzy_partition_size; i++) {
        yi0 = fuzzy_partitions[i];

        for (j = 0; j < euler_step_size; j++) {
            k1  = function_problem(x_domain[i], yi0);
            k2  = function_problem(x_domain[i] + h/2, yi0 + 0.5 * k1 * h);
            k3  = function_problem(x_domain[i] + h/2, yi0 + 0.5 * k2 * h);
            k4  = function_problem(x_domain[i] + h, yi0 + k3 * h);

            yij = yi0 + 1.0 / 6 * h * (k1 + k2 + k3 + k4);
            yi0 = yij;
        }
    }

    printf("Precission: %d\n", sizeof(num));

    return 0;
}
