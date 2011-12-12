#!/bin/bash

#-------------------------------------------------------------------
# Efetua envio entre servidores - processamento fora do fluxo padrao
#-------------------------------------------------------------------

# Chamada de parametros para a instancia
. SciELO.inc

  ./FragEnvSCL31.${SIGLA2}.sh
  ./FragEnvSCL32.${SIGLA2}.sh
# ./FragEnvSCL33.${SIGLA2}.sh
