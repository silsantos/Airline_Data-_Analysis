#!/bin/bash

echo 'O número de vôos que precisaram ser redirecionados: '

cat data/2006-sample.csv | cut -d, -f24 | grep 1 | wc -l $1
