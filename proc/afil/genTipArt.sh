#!/bin/bash
# ------------------------------------------------------------------------- #
# genTipArt.sh - Geracao do indice de Tipo de Artigo
# ------------------------------------------------------------------------- #
#      entrada : sufixo para o nome do indice
#        saida : indice TipArt gerado e copiado em iah/library
#     corrente : /bases/sss.nnn/proc/afil
#      chamada : ./genTipArt.sh
#      exemplo : nohup ./genTipArt.sh >& ../outs/YYYYMMDDTipArt.out &
# dependencias : Assume que a estrutura de diretorios inclua:
#                   /bases/sss.nnn/bases/iah/library
#                   /bases/sss.nnn/proc/afil
#                   /bases/sss.nnn/proc/afil/tabs
#                   /bases/sss.nnn/proc/afil/tabs/BR
#                   /bases/sss.nnn/proc/outs
#                Base TipArt e invertido presentes em ./tabs
#                Formato fstTipArt.pft presente em ./tabs
#  comentarios : 
#  observacoes : 
# ------------------------------------------------------------------------- #
#   DATA    Resp              Comentarios
# 20071101  MBottura/FJLopes  Edicao original
#

# ========================================================================= #

TPR="start"
. log

HINIC=`date '+%s'`
HRINI=`date '+%Y.%m.%d %H:%M:%S'`
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] $0 $1 $2 $3 $4 $5"

# ------------------------------------------------------------------------- #

TPR="iffatal"
MSG="Gera indice TipArt"
$LIND/mx ../temp/artigoH "proc=if replace(v2,'\"','')='' then 'd2' fi" "fst=1 0 @tabs/fstTipArt.pft" fullinv=TipArt$1 tell=10000
. log

TPR="iffatal"
MSG="Transfere TipArt para iah/library"
cp TipArt$1.* ../../bases/iah/library
. log

# ------------------------------------------------------------------------- #
# Contabiliza tempo de processamento e gera relato da ultima execucao
echo ""
HRFIM=`date '+%Y.%m.%d %H:%M:%S'`
HFINI=`date '+%s'`
TPROC=`expr $HFINI - $HINIC`
echo "Tempo decorrido: $TPROC"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# Determina o nome do Shell chamado (sem o eventual path)
LGPRC=`expr "/$0" : '.*/\(.*\)'`

echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]" >>$LGRAIZ/$LGPRD/outs/$LGPRC.tim
echo "Tempo transcorrido: $TPROC [s]"

echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HINIC}</INICIO_PROC>"  >$LGRAIZ/$LGPRD/outs/time_$LGPRC.txt
echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HFINI}</FIM_PROC>"       >>$LGRAIZ/$LGPRD/outs/time_$LGPRC.txt
echo " <DURACAO_PROC UNIT=\"SEC\">${TPROC}</DURACAO_PROC>"                         >>$LGRAIZ/$LGPRD/outs/time_$LGPRC.txt

unset HINIC
unset HFINI
unset TPROC

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] $0 $1 $2 $3 $4 $5"
TPR="end"
. log

