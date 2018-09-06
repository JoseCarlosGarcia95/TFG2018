#include <stdlib.h>
#include <stdio.h>
#include <math.h>

float f_simple(float x) {
    return pow((x-1), 8);
}

float f_prima_simple(float x) {
    return 8 * pow((x-1), 7);
}

double f_double(double x) {
    return pow((x-1), 8);
}

double f_prima_double(double x) {
    return 8 * pow((x-1), 7);
}

int main(int argc, char ** args) {
    int i, j;
    float x0, x1;
    double x0d, x1d;

    x1 = 0;
    i = 0;
    
    do {
	x0 = x1;
	x1 = x0 - f_simple(x0) / f_prima_simple(x0);

	i++;
    } while (x0 - x1 != 0);

    x1d = x1;
    j   = 0;
    do {
	x0d = x1d;
	x1d = x0d - f_double(x0d) / f_prima_double(x0d);

	j++;
    } while (x0d - x1d != 0);

    printf("%d %d %d %.30f\n", i, j, i+j, x1d);
}
