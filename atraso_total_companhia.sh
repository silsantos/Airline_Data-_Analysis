#!/usr/bin/env bash

function usage() {
cat << EOF

  Uso: $(basename "$0") <arquivo_de_dados> <codigo_da_companhia_aerea>

  Descrição: busca em um arquivo csv o tempo de atraso total
  para a companhia Delta Airlines (código DL).

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
      COMPANY="DL"
      ;;
    esac
  elif [[ $# == 2 ]]; then
    DATAFILE=$1
    COMPANY="$2"
  else
  cat << EOF
  
    Número inválido de argumentos: $#
EOF
    usage
    exit 0
  fi
}

function total_delay_by_company() {
  FILTERED_DATA=$(awk -F',' 'NF==29 && NR>1' $1 | grep -w $COMPANY)
  DELAYS_PER_FLIGHT=$(echo "$FILTERED_DATA" | awk -F',' '{print($14+$15)}' | grep -v -)
  TOTAL_DELAY=$(echo "$DELAYS_PER_FLIGHT" | paste -s -d+ | bc )
  cat << EOF

  O atraso total para a companhia '$COMPANY' é de $TOTAL_DELAY minutos.
EOF
}

function main() {
  arg_parse "$@"
  total_delay_by_company $DATAFILE
}

main "$@"
