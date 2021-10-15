#!/usr/bin/env bash

function usage() {
cat << EOF

  Uso: $(basename "$0") arquivo_de_dados

  Descrição: busca em um arquivo csv o maior tempo de voo (AirTime).

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

function sort_by_AirTime() {
  FLIGHT_DATA=$(awk -F',' 'NF==29 && NR>1' $1 | sort --field-separator="," -k 14 -nr | head -n1)
  FLIGHT_NUM=$(echo $FLIGHT_DATA | cut -d, -f11)
  AIRTIME=$(echo $FLIGHT_DATA | cut -d, -f14)

  cat << EOF
    
  O voo com maior tempo de voo é o voo número: $FLIGHT_NUM
  Esse voo teve um tempo no ar de $AIRTIME minutos.
EOF
}

function main() {
  arg_parse "$@"
  sort_by_AirTime $DATAFILE
}

main "$@"
