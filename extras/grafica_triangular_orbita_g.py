#!/usr/bin/python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(6.673, 6.675, 100000)

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
plt.plot(x, vector_triangular_membership_function(6.67357, 6.67424, 6.67491, x), label='Numero triangular')

plt.xlabel('Numeros reales')
plt.ylabel('Grado pertenencia')

plt.title("Numero difuso")

plt.legend()

fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)

plt.savefig('../graphics/grafica_triangular_orbita_g.pdf', transparent=True, dpi=512)
