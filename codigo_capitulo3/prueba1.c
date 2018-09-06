#include <stdlib.h>
#include <stdio.h>

int main(int argc, char ** args) {
    int itera, i, *vector;

    itera = atoi(args[1]);

    vector = malloc(sizeof(int) * itera);
    
    for (i = 0; i < itera; i++) {
	vector[i] = i;
    }

    for (i = 0; i < itera; i++) {
	vector[i] = i + 1;
    }
}

