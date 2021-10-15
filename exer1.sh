#!/bin/bash

var_companhia="$1"
# definindo a variavel companhia

echo 'A quantidade de atrasos da companhia escolhida foi:'

cat data/2006-sample.csv | cut -d, -f9,15,16 | grep $1 | cut -d, -f2,3 | grep '.,.' | wc -l
