#!/usr/bin/python
import numpy
import math
import sys

# Configuration
FUZZY_PARTITIONS_SIZE = int(sys.argv[1])
EULER_STEP_SIZE       = int(sys.argv[2])

# EDO definitions
def function_problem(x, y):
    return 2*x - 3*y + 1

def function_solution(x, ai):
    return (math.exp(-3*x) * (-1 + ai * 9 + math.exp(3*x) * (1 + 6*x))) / 9
    
# Variables
fuzzy_partitions      = numpy.linspace(-1, 1, FUZZY_PARTITIONS_SIZE)
x_domain              = numpy.linspace(0, 1, EULER_STEP_SIZE)

for ai in fuzzy_partitions:
    yi0 = ai

    for xj in x_domain:
        yij = yi0 + 1.0/EULER_STEP_SIZE * function_problem(xj, yi0)
        yi0 = yij

        # print("Error={}".format(abs(function_solution(xj, ai) - yi0)))
