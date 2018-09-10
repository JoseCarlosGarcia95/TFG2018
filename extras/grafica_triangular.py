#!/usr/bin/python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(-1, 3, 1000)

def vector_triangular_membership_function(a, b, c,  t):
    im = list()

    for t0 in t:
        im.append(triangular_membership_function(a, b, c, t0))
    return im


def triangular_membership_function(a, b, c, t):
    if t >= a and t <= b:
        return (t-a) / (b-a)
    elif t > b and t <= c:
        return (c - t) / (c - b)
    return 0

plt.style.use('fivethirtyeight')
plt.plot(x, vector_triangular_membership_function(0, 1, 2, x), label='Numero triangular')

plt.xlabel('Numeros reales')
plt.ylabel('Grado pertenencia')

plt.title("Numero difuso")

plt.legend()

plt.show()
