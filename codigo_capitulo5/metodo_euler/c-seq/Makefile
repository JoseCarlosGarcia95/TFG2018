all:
	gcc -o basic-simple main.c -lm
	gcc -o fastmath-simple main.c -lm -Ofast

	gcc -o basic-double main.c -lm -D DOUBLE_PRECCISION
	gcc -o fastmath-double main.c -lm -Ofast -D DOUBLE_PRECCISION
	gcc -o o3-double main.c -lm -O3 -D DOUBLE_PRECCISION

	
