#!/usr/bin/python
import os
from subprocess import call
import time
import json

# Variables
results = {}
for executable in ['./fastmath-simple', './fastmath-double', './basic-simple', './basic-double']:
    
    results[executable] = []

    for i in range(0, 10000):
        print("[{}] Running test to: ".format(i) + executable)

        start_time = time.time()
        call([executable, '100', str(i)])
        results[executable].append(time.time() - start_time)


output = json.dumps(results)

newfile = open("results.json", 'w')
newfile.write(output)
newfile.close()