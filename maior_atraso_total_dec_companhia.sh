#!/usr/bin/env bash

COMP_DICT=data/companies.csv

function usage() {
cat << EOF

  Uso: $(basename "$0") arquivo_de_dados

  Descrição: busca em um arquivo csv a companhia com
  maior atraso total na decolagem (DepDelay).

    -h | --help       Mostrar essa ajuda
EOF
}

function arg_parse() {
  if [[ $# == 0 ]]; then
    cat << EOF

    Não foram fornecidos argumentos.
EOF
    usage
    exit 0
  elif [[ $# == 1 ]]; then
    case $1 in 
      -h | --help)
        usage
        exit 0
        ;;
      *)
        if [[ -f $1 ]]; then
          DATAFILE=$1
        else
          cat << EOF 

          Arquivo não existente.
EOF
          exit 0
        fi
      ;;
    esac
  else
  cat << EOF
  
    Número inválido de argumentos: $#
EOF
    usage
    exit 0
  fi
}

function total_DepDelay_by_company() {
  COMPANIES=$(tail -n +2 $1 | cut -d, -f9 | sort | uniq)
  TOTALS=""
  for COMP in $COMPANIES; do
    TOTAL=$(grep -w $COMP $1 | cut -d, -f15 | grep -v - | sed --expression='/^$/d' | paste -s -d+ | bc)
    TOTALS+="$COMP,$TOTAL\n"
  done
}

function get_greatest_total_delay() {
  SORTED_LIST=$(echo -e "$1" | sed --expression='/^$/d' | sort -t, -n -k 2)
  DELAY=$(echo "$SORTED_LIST" | tail -n1 | cut -d, -f2)
  CODE=$(echo "$SORTED_LIST" | tail -n1 | cut -d, -f1)
  if [[ -f $COMP_DICT ]]; then
    COMPANY=$(grep -w "$CODE" $COMP_DICT | cut -d, -f2)
  else
    COMPANY=$CODE
  fi
  cat << EOF
  
  A companhia com maior atraso total na decolagem é:
    $COMPANY com atraso de $DELAY minutos.
EOF
}

function main() {
  arg_parse "$@"
  total_DepDelay_by_company $1
  get_greatest_total_delay $TOTALS
}

main "$@"
