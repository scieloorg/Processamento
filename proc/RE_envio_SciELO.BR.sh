#!/bin/bash

TPR="start"
. log

echo "Gera os indices compactos para o SciELO.BR"

. FragCnvIDX.BR.sh
. FragCnvID2.BR.sh

echo "Envia arquivos de SciELO.BR mais iAH, nlinks, e lattes"

. FragEnvHM1.BR.sh
. FragEnvHM2.BR.sh

TPR="end"
. log
