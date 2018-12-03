#ifndef HEADER_FUZZY_SOLVER
#define HEADER_FUZZY_SOLVER

typedef double(*edo_fuzzy_function)(double);

typedef struct t_edo_fuzzy_solver {
    double * fuzzy_set;
    unsigned int fuzzy_set_length;
    double tol;
} edo_fuzzy_solver;


typedef struct t_edo_fuzzy_solution {
    double ** x_values;
    double ** y_values;

    edo_fuzzy_solver solver;
    unsigned int points;
} edo_fuzzy_solution;

typedef enum t_edo_fuzzy_solver_error {
    EFS_E_OK,
    EFS_E_CUDA_ERROR,
} edo_fuzzy_solver_error;

edo_fuzzy_solver_error edo_fuzzy_solver_create(double *, unsigned int, double, edo_fuzzy_solver*);
edo_fuzzy_solver_error edo_fuzzy_solver_solve(edo_fuzzy_solver, edo_fuzzy_solution *);
double edo_fuzzy_solver_evaluate(double, unsigned int, edo_fuzzy_solution*);
#endif
