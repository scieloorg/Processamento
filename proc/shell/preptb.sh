# ------------------------------------------------------------------------- #
# PREPTB.SH - Prepara tabelas diversas
# ------------------------------------------------------------------------- #
#  sintaxe: shell/preptb.sh
#  entrada: arquivos "fonte" no sub txt
#    saida: bases de dados criadas no sub gizmo e gizmo/BR
# corrente: /bases/scl.000/proc
#    notas: Os arquivos TXT sao os originais da SciELO3
#           Sao geradas versoes FFI e 10/30 diferenciadas pelo sufixo FF
# ------------------------------------------------------------------------- #
#   Data    Responsavel        Comentario
# 20051208  FJLopes            Edicao original
# 20101209  FJLopes            Adapatado para uso de CISIS G4
#

echo "Iniciando em `date '+ %Y%m%d %H%M%S'` o processamento de preparo de tabelas - ${0} ${1} ${2}"
export HORA_INICIO_PREPTB=`date '+ %s'`
sleep 1

TPR="start"
. log
# ------------------------------------------------------------------------- #

echo "Verifica existencia de diretorios"
if [ ! -d "gizmo" ]
then
  echo "Cria diretorio gizmo"
  mkdir gizmo
fi
if [ ! -d "gizmo/BR" ]
then
  echo "Cria diretorio BR"
  mkdir gizmo/BR
fi

echo "Cria e inverte tabela tbXuf"
$FFIG4/mx "seq=txt/tbXuf.txt  " "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=gizmo/BR/tbXufFF  fullinv=gizmoBR/tbXufFF
echo "Cria e inverte tabela tbXcid"
$FFIG4/mx "seq=txt/tbXcid.txt " "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=gizmo/BR/tbXcidFF fullinv=gizmo/BR/tbXcidFF
echo "Cria e inverte tabela tbXorg"
$FFIG4/mx "seq=txt/tbXorg.txt " "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=gizmo/BR/tbXorgFF fullinv=gizmo/BR/tbXorgFF
echo "Cria e inverte tabela gizAfPais"
$FFIG4/mx "seq=txt/gizAfPais.txt" "proc=if replace(v2,'\"','')='' then 'd2' fi" "fst=1 0 v1" create=gizmo/gizAfPaisFF fullinv=gizmo/gizAfPaisFF

# ------------------------------------------------------------------------- #

HORA_FIM=`date '+ %s'`
DURACAO=`expr $HORA_FIM - $HORA_INICIO_PREPTB`
HORAS=`expr $DURACAO / 60 /60`
MINUTOS=`expr $DURACAO / 60 % 60`
SEGUNDOS=`expr $DURACAO % 60`
echo "Tempo transcorrido: $DURACAO [s]"
echo "<PROCESS name=\"preptb.sh\">" > temp/preptb.xml
echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HORA_INICIO}</INICIO_PROC>" >> temp/preptb.xml
echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HORA_FIM}</FIM_PROC>" >> temp/preptb.xml
echo " <DURACAO_PROC UNIT=\"SEC\">${DURACAO}</DURACAO_PROC>" >> temp/preptb.xml
echo " <PROCESSING_TIME UNIT=\"human\">${HORAS}h ${MINUTOS}m ${SEGUNDOS}s</PROCESSING_TIME>" >> temp/preptb.xml
echo "</PROCESS>" >> temp/preptb.xml

unset HORA_INICIO_PREPTB
unset HORA_FIM
unset DURACAO
unset HORAS
unset MINUTOS
unset SEGUNDOS

echo "Termino de processamento em `date '+ %Y%m%d %H%M%S'` de preapro de tabelas - ${0} ${1} ${2}"
TPR="end"
. log
