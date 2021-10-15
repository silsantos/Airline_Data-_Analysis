#!/bin/bash

cat data/2006-sample.csv | sort -n -t, -k16,17 | cut -d, -f16,17 | grep -v - | grep 'JFK' | cut -d, -f1 > colunas.txt

echo 'tempo total de atrasos para a decolagem de vôos no aeroporto JFK: '

awk '{SUM += $1} END {print SUM}' colunas.txt
