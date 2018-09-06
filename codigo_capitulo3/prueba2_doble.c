#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double f_double(double x) {
    return pow((x-1), 8);
}

double f_prima_double(double x) {
    return 8 * pow((x-1), 7);
}

int main(int argc, char ** args) {
    int i;
    double x0, x1;

    x1 = 0;
    i = 0;
    
    do {
	x0 = x1;
	x1 = x0 - f_double(x0) / f_prima_double(x0);

	i++;
    } while (x0 - x1 != 0);

    printf("%d %.30f\n", i, x1);
}
