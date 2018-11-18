#!/usr/bin/python
import os
from subprocess import call
import time
import json

# Variables
results = {}
for executable in ['./fastmath-simple', './fastmath-double']:
    if executable == 'main.c' or executable == 'Makefile':
        continue

    results[executable] = []

    for i in range(0, 10000):
        print("[{}] Running test to: ".format(i*10000) + executable)

        start_time = time.time()
        call([executable, str(10000*i), str(i*10000)])
        results[executable].append(time.time() - start_time)


output = json.dumps(results)

newfile = open("results2.json", 'w')
newfile.write(output)
newfile.close()