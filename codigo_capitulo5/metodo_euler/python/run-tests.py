#!/usr/bin/python
import os
from subprocess import call
import time
import json

# Configuration
RUN='main.py'

# Variables
results = {}

for folder in os.listdir('.'):

    if os.path.isdir(folder):
        script  = folder + "/" + RUN 
        results[script] = []

        for i in range(0, 10000):
            print("[{}] Running test to: ".format(i) + script)

            start_time = time.time()
            call([script, '100', str(i)])
            results[script].append(time.time() - start_time)


output = json.dumps(results)

newfile = open("results.json", 'w')
newfile.write(output)
newfile.close()