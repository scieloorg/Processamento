#!/bin/bash
# ------------------------------------------------------------------------- #
# toolPID2DOIlist.sh - Toma lista de PID e cria lista de processamento DOI
# ------------------------------------------------------------------------- #
#      Entrada: in_listfile - arquivo com lista de PIDs
#               out_listfile- arquivo para receber a lista de processamento
#        Saida: lista de processamento de DOI
#     Corrente: .../proc
#      Chamada: toolPID2DOIlist.sh <FILENAME.EXT>
#      Exemplo: ./toolPID2DOIlist.sh PIDs.lst > ProcDOI.lst
#  Comentarios: Com REF LOOKUP monta os parametros da lista de processamento
#               DESTROI O ARQUIVO out_filename SE EXISTIR
#  Observacoes: Pressupoe que o campo v882 sempre resolva a parada de v n s
#               Deixa o formato PIDOI.pft em proc/pft
# Dependencias: 
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis           Comentarios
# 20090422  MBottura/FJLopes       Edicao original
#
# ========================================================================= #
#                                  Funcoes                                  #
# ========================================================================= #

# ========================================================================= #
# function_name - Finalidade da funcao em texto resumido
# PARM $1 - Descricao do parametro 1
# PARM $N - Descricao do parametro N
#
#funcao1 () {
#}
#
# ========================================================================= #

TPR="start"
. log

HINIC=`date '+%s'`
HRINI=`date '+%Y.%m.%d %H:%M:%S'`
echo "[TIME-STAMP] Em `date '+%Y.%m.%d %H:%M:%S'`  iniciando  $0 $1 $2 $3 $4 $5"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# Se nao existe cria diretorio para OUTs diversos
[ -d $LGRAIZ/$LGPRD/outs/ ] || mkdir $LGRAIZ/$LGPRD/outs/

# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
#               S E U   C O D I G O   P A R T E   D A Q U I                 #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #

# Verifica se recebe os dois parametrso obrigatorios
if [ $# -ne "2" ]
then
  TPR="fatal"
  MSG="[PID2DOI] Sintaxe: $0 <in_listfile.ext> <out_listfile.ext>"
  . log
fi

# Monta o formato que faz os REF LOOK-UP necessarios e guarda em pft
echo "Monta o formato de montagem da lista de processamento"
echo "if v1>'' then s1:=(v1*1.9/),ref(['../bases/title/title']l(['../bases/title/title'],'LOC='s1),v68,' '),ref(['../bases/artigo/artigo']l(['../bases/artigo/artigo']'HR='v1),|v|v882^v,|n|v882^n,|s|v882^s),' 'v1.18/ fi" > pft/PIDOI.pft

# Processa cada elemento do arquivo de entrada
TPR="iffatal"
MSG="[PID2DOI] Montando lista de processamento de DOI"
mx seq=$1 lw=0 "pft=@pft/PIDOI.pft" now | tee $2
. log

# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
#              S E U   C O D I G O   T E R M I N A   A Q U I                #
# ------------------------------------------------------------------------- #
# ------------------------------------------------------------------------- #
# Gera relatorio de processamento

## #     12345678901
## echo "13       - Gera relatorio de dados de processamento"
## tpl.org/statis.sh

# ------------------------------------------------------------------------- #
# Contabiliza tempo de processamento e gera relato da ultima execucao
echo ""
echo "[TIME-STAMP] Em `date '+%Y.%m.%d %H:%M:%S'` terminando  $0 $1 $2 $3 $4 $5"
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

echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]">>$LGRAIZ/$LGPRD/outs/$LGPRC.tim
echo "Tempo transcorrido: $TPROC [s]"

echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HINIC}</INICIO_PROC>"  > $LGRAIZ/$LGPRD/outs/time_ldd_${1}.txt
echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HFINI}</FIM_PROC>"       >> $LGRAIZ/$LGPRD/outs/time_ldd_${1}.txt
echo " <DURACAO_PROC UNIT=\"SEC\">${TPROC}</DURACAO_PROC>"                         >> $LGRAIZ/$LGPRD/outs/time_ldd_${1}.txt

unset HINIC
unset HFINI
unset TPROC

TPR="end"
. log
