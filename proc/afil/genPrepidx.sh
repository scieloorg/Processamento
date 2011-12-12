#!/bin/bash
# ------------------------------------------------------------------------- #
# genPrepidx.sh - Preparo para processamento de indices diversos
# ------------------------------------------------------------------------- #
#      entrada : Nenhuma
#        saida : Tabelas em versao lind e FFI geradas em tabs e tabs/BR
#     corrente : /bases/sss.nnn/proc/afil
#      chamada : ./genPrepIdx.sh
#      exemplo : nohup ./genPrepIdx.sh >& ../outs/arquivo_out.out &
# dependencias : Assume que a estrutura de diretorios eh como mostrado:
#                 /bases/sss.nnn/bases/artigo
#                 /bases/sss.nnn/proc
#                 /bases/sss.nnn/proc/afil
#                 /bases/sss.nnn/proc/afil/tabs
#                 /bases/sss.nnn/temp
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

# Ajusta ambiente opracional para operar com giga-base
echo "mstxl=4" > $TABS/GBASE.cip
export CIPAR=$TABS/GBASE.cip

# ------------------------------------------------------------------------- #
echo "Cria uma versao da base artigos so com registro tipo H"
cd ..

TPR="iffatal"
MSG="Cria base artigoH"
$LIND/mx null count=0 create=temp/artigoH -all now
. log

TPR="iffatal"
MSG="Filtra registro H para artigoH"
$LIND/mx ../bases/artigo/artigo "proc=@prc/Article.prc" btell=0 TP=H copy=temp/artigoH tell=5000 -all now
. log

cd -

# ------------------------------------------------------------------------- #
echo "Gera tabelas auxiliares necessarias ao processamento de afiliacao"

echo "Cria se necessario diretorio BR"
if [ ! -d tabs/BR ]
then
	mkdir tabs/BR
fi

echo "Tabela de unidade da federacao versao FFI"
TPR="iffatal"
MSG="Gera tabela de UF em FFI"
$FFI/mx "seq=tabs/T_tbXuf.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXuf_FFI  fullinv=tabs/BR/tbXuf_FFI
. log
echo "Tabela de unidade da federacao versao LIND"
TPR="iffatal"
MSG="Gera tabela de UF"
$FFI/mx "seq=tabs/T_tbXuf.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXuf  fullinv=tabs/BR/tbXuf
. log

echo "Tabela de cidades brasileiras versao FFI"
TPR="iffatal"
MSG="Gera tabela de cidades brasileiras em FFI"
$FFI/mx "seq=tabs/T_tbXcid.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXcid_FFI fullinv=tabs/BR/tbXcid_FFI
. log
echo "Tabela de cidades brasileiras versao LIND"
TPR="iffatal"
MSG="Gera tabela de cidades brasileiras"
$LIND/mx "seq=tabs/T_tbXcid.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXcid fullinv=tabs/BR/tbXcid
. log

echo "Tabela de organizacoes brasileiras versao FFI"
TPR="iffatal"
MSG="Gera tabela de organizacoes brasileiras em FFI"
$FFI/mx "seq=tabs/T_tbXorg.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXorg_FFI fullinv=tabs/BR/tbXorg_FFI
. log
echo "Tabela de organizacoes brasileiras versao LIND"
TPR="iffatal"
MSG="Gera tabela de organizacoes brasileiras"
$LIND/mx "seq=tabs/T_tbXorg.txt	" "proc=if replace(v1,' ','')>'' then 'd*' fi" "fst=1 0 replace(v2,'\"','')" create=tabs/BR/tbXorg fullinv=tabs/BR/tbXorg
. log

echo "Tabela de tipos de artigos versao FFI"
TPR="iffatal"
MSG="Cria e inverte tipos de artigos em FFI"
$LFFI/mx "seq=tabs/G_TipArt.txt" "fst=1 0 v1" create=tabs/TipArt_FFI fullinv=tabs/TipArt_FFI
. log
echo "Tabela de tipos de artigos versao LIND"
TPR="iffatal"
MSG="Cria e inverte tipos de artigos"
$LIND/mx "seq=tabs/G_TipArt.txt" "fst=1 0 v1" create=tabs/TipArt fullinv=tabs/TipArt
. log

echo "Tabela de correcao de paises versao FFI"
TPR="iffatal"
MSG="Cria e inverte gizmo de paises em FFI"
$FFI/mx "seq=tabs/G_AfPais.txt" "proc=if replace(v2,'\"','')='' then 'd2' fi" "fst=1 0 v1" create=tabs/gizAfPais_FFI fullinv=tabs/gizAfPais_FFI
. log
echo "Tabela de correcao de paises versao LIND"
TPR="iffatal"
MSG="Cria e inverte gizmo de paises"
$LIND/mx "seq=tabs/G_AfPais.txt" "proc=if replace(v2,'\"','')='' then 'd2' fi" "fst=1 0 v1" create=tabs/gizAfPais fullinv=tabs/gizAfPais
. log

# ------------------------------------------------------------------------- #
# Limpa area de trabalho

if [ -f $TABS/GBASE.cip ]
then
	rm $TABS/GBASE.cip
fi

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

