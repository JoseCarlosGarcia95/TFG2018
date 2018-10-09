#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import csv
import matplotlib.pyplot as plt
import matplotlib
import numpy as np

log = sys.argv[1]

with open(log, 'rb') as csvfile:
    results = csv.reader(csvfile)

    x = []
    graph1 = []
    graph2 = []
    
    for row in results:
        x.append(int(row[0]))
        graph1.append(int(row[1]))
        graph2.append(int(row[2]))

    plt.style.use('fivethirtyeight')

    plt.plot(x, graph1, label='Python')
    plt.plot(x, graph2, label='C')

    plt.xlabel('Iteraciones')
    plt.ylabel('Tiempo de ejecucion (ms)')

    plt.legend()
    
    ax = plt.gca()
    ax.get_xaxis().get_major_formatter().set_scientific(False)


    fig = plt.gcf()
    fig.set_size_inches(18.5, 10.5)

    plt.savefig('../graphics/grafica_c_vs_python.pdf', transparent=True, dpi=1024)
