#!/usr/bin/env bash

function usage() {
cat << EOF

  Uso: $(basename "$0") <arquivo_de_dados> <codigo_do_aeroporto>

  Descrição: busca em um arquivo csv o tempo total de atraso nos pousos
  para o Aeroporto Internacional de Los Angeles (LAX).

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
      DATAFILE=$1
      AIRPORT="LAX"
      ;;
    esac
  elif [[ $# == 2 ]]; then
    DATAFILE=$1
    AIRPORT="$2"
  else
  cat << EOF
  
    Número inválido de argumentos: $#
EOF
    usage
    exit 0
  fi
}

function total_delay_by_company() {
  FILTERED_DATA=$(awk -F',' 'NF==29 && NR>1' $1 | grep -w $AIRPORT)
  DELAY_PER_FLIGHT=$(echo "$FILTERED_DATA" | cut -d, -f15 | grep -v - | sed --expression='/^$/d')
  TOTAL_DELAY=$(echo "$DELAY_PER_FLIGHT" | paste -s -d+ | bc | sed --expression='s/.0//')
  cat << EOF

  O atraso total nos pousos do aeroporto '$AIRPORT' é de $TOTAL_DELAY minutos.
EOF
}

function main() {
  arg_parse "$@"
  total_delay_by_company $DATAFILE
}

main "$@"
