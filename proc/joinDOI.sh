#!/bin/bash
# ------------------------------------------------------------------------- #
# joinDOI.sh - Consolida as bases DOI dos issues em um soh
# ------------------------------------------------------------------------- #
#      entrada : base ../bases-work/title/title
#                bases ../bases-work/doi/RRRR/VvvNnn/VvvNnn
#        saida : base ../bases-work/doi
#     corrente : /bases/???.000/proc
#      chamada : joinDOI.sh
#      exemplo : ./joinDIO.sh
# dependencias : Assume que a estrutura de diretorios inclua:
#                   /RAIZ/PROD/outs
#  comentarios : 
#  observacoes : 
# ------------------------------------------------------------------------- #
#   DATA    Resp                Comentarios
# 20081028  AOTardelli/FJLopes  Edicao original
#

TPR="start"
. log

HINIC=`date '+%s'`
HRINI=`date '+%Y.%m.%d %H:%M:%S'`
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] $0 $1 $2 $3 $4 $5"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`

# ------------------------------------------------------------------------- #
# Testa a chamada e prepara parametros de operacao

if [ "$#" -ne "1" ]
then
  TPR="fatal"
  MSG="Sintax: joinDOI.sh sigla"
  . log
fi

ID=`echo $1 | tr [:upper:] [:lower:]`
if [ ! "$ID" = `echo $LGPRD | cut -d "." -f "1"` ]
then
  TPR="fatal"
  MSG="Sigla errada"
  . log
fi
# ------------------------------------------------------------------------- #
# Garante inexistencia de base DOI consolidada
  [ -f ../bases-work/doi/DOI.xrf ] && rm ../bases-work/doi/DOI.*

## Gera estrutura de base grande
  echo "mstxl=4" > gbase.cip
  mx cipar=gbase.cip tmp create=../bases-work/doi/DOI count=0 now

# Varre todas as revistas segundo seu status (Corrente) anotado em title
for ACRON in `mx ../bases-work/title/title "pft=if s(mpu,v50,mpl)='C' then v68/ fi" now`
do
	echo ${ACRON}
        if [ -d ../bases-work/doi/${ACRON} ]
        then
		echo ${ACRON}
		# Varre cada issue do titulo
		for VOLNUM in `ls ../bases-work/doi/${ACRON}`
		do
			echo "        - ${VOLNUM}"
			# Appenda dados do fasciculo na base geral
			mx ../bases-work/doi/${ACRON}/${VOLNUM}/${VOLNUM} "proc='d312<312 0>${ACRON}/${VOLNUM}</312>'" append=../bases-work/doi/DOI now -all
		done
	fi
done

# Gera um ISO da base DOI consolidada
mx ../bases-work/doi/DOI iso=../bases-work/doi/DOI.iso -all now tell=100

# Prove uma copia de DOI.iso em bases/doi
cp ../bases-work/doi/DOI.iso ../bases/doi

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

