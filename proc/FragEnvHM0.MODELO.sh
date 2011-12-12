#!/bin/bash

#-------------------------------------------------------------------
# Efetua envio entre servidores - processamento fora do fluxo padrao
#-------------------------------------------------------------------

# Chamada de parametros para a instancia
. SciELO.inc

  ./FragEnvHM1.${SIGLA2}.sh
  ./FragEnvHM2.${SIGLA2}.sh
# ./FragEnvHM3.${SIGLA2}.sh
