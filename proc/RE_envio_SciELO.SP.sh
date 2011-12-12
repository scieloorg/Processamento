#!/bin/bash

TPR="start"
. log

echo "Gera os indices compactos para o SciELO.SP"

. FragCnvIDX.SP.sh
. FragCnvID2.SP.sh

echo "Envia arquivos de SciELO.SP mais iAH, nlinks, e lattes"

. FragEnvHM1.SP.sh
. FragEnvHM2.SP.sh

TPR="end"
. log

