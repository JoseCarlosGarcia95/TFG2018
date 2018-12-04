#!/usr/bin/python
import json
import matplotlib.pyplot as plt
import numpy as np

# Read results JSON.
results_file = open('results.json', 'r')
results      = json.loads(results_file.read())
results_file.close()

plt.style.use('fivethirtyeight')

def reduce(l2, points):
    l      = list(l2)
    output = []
    step   = len(l) / points

    for i in range(0, points):
        output.append(l[step * i])
    return output

for test in results.keys():
    x   = np.linspace(0, 10000**2, 10000)
    y   = results[test]
    fit = np.polyfit(x,y,2)
    fit_fn = np.poly1d(fit) 

    plt.plot(reduce(x, 2), reduce(fit_fn(x), 2), '-', label=test)

    print "El test {} ha tardado {} segundos".format(test, sum(y))

    

plt.xlabel('Particion')
plt.ylabel('Tiempo')
plt.legend(loc='upper left')


fig = plt.gcf()
fig.set_size_inches(18.5, 10.5)

plt.savefig('../../../graphics/grafica_cseq_euler_comparativa.pdf', transparent=True, dpi=1024)
