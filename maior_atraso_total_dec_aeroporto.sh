#!/usr/bin/env bash

function usage() {
cat << EOF

  Uso: $(basename "$0") arquivo_de_dados

  Descrição: busca em um arquivo csv o aeroporto com
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

function total_DepDelay_by_airport() {
  AIRPORTS=$(tail -n +2 $1 | cut -d, -f17 | sort | uniq)
  TOTALS=""
  for APT in $AIRPORTS; do
    TOTAL=$(grep -w $APT $1 | cut -d, -f15 | grep -v - | sed --expression='/^$/d' | paste -s -d+ | bc)
    TOTALS+="$APT,$TOTAL\n"
  done
}

function get_greatest_total_delay() {
  SORTED_LIST=$(echo -e "$1" | sort -t, -n -k 2 | grep .....)
  DELAY=$(echo "$SORTED_LIST" | tail -n1 | cut -d, -f2)
  CODE=$(echo "$SORTED_LIST" | tail -n1 | cut -d, -f1)
  cat << EOF
  
  O aeroporto com maior atraso total na decolagem é:
    $CODE com atraso de $DELAY minutos.
EOF
}

function main() {
  arg_parse "$@"
  total_DepDelay_by_airport $1
  get_greatest_total_delay $TOTALS
}

main "$@"
