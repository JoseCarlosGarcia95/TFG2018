#include <stdlib.h>
#include <stdio.h>
#include <math.h>

float f_simple(float x) {
    return pow((x-1), 8);
}

float f_prima_simple(float x) {
    return 8 * pow((x-1), 7);
}

int main(int argc, char ** args) {
    int i;
    float x0, x1;

    x1 = 0;
    i = 0;
    
    do {
	x0 = x1;
	x1 = x0 - f_simple(x0) / f_prima_simple(x0);

	i++;
    } while (x0 - x1 != 0);

    printf("%d %.30f\n", i, x1);
}
