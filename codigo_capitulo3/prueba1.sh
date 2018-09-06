#!/bin/bash

# Configuration

PY_EXEC="./prueba1.py"
C_EXEC="./prueba1"
RESULT="prueba1.log"

> $RESULT

for i in {1..10}; do
    ITERA=$((10 ** $i))

    echo "Python: Testing $ITERA"
    START_PYTHON=`date +%s%3N`
    $PY_EXEC $ITERA
    END_PYTHON=`date +%s%3N`

    echo "C: Testing $ITERA"
    START_C=`date +%s%3N`
    $C_EXEC $ITERA
    END_C=`date +%s%3N`

    RUNTIME_PYTHON=$((END_PYTHON - START_PYTHON))
    RUNTIME_C=$((END_C - START_C))

    echo "$ITERA,$RUNTIME_PYTHON,$RUNTIME_C" >> $RESULT

done
