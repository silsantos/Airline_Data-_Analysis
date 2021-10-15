#!/bin/bash


echo 'Voo com maior atraso na saída'

cat data/2006-sample.csv | sort -n -t, -k16 | cut -d, -f10 | tail -1 $1
