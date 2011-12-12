#!/bin/bash
# ------------------------------------------------------------------------- #
# estBIBLIOxml.sh - Coleta de dados estatisticos de Bibliometria
# ------------------------------------------------------------------------- #
#      Entrada: Parametros e arquivos de entrada do shell
#        Saida: arquivo xml
#     Corrente: /bases/???.000/proc
#      Chamada: ./estBIBLIOxml.sh
#      Exemplo: nohup ./estBIBLIOxml.sh &> outs/estBIBLIOxml.yyymmdd.out &
#  Comentarios: Todo e qualquer comentario sobre algoritmo, metodos,
#                 descricao de arquivos e etc.
#  Observacoes: Observacoes relevantes para o processamento
# Dependencias: Relacoes de dependencia para execucao, como arquivos
#                 auxiliares esperados, estrutura de diretorios, etc.
#               NECESSARIAMENTE entre o servidor de trigramas e esta maquina
#                 deve haver uma CHAVE PUBLICA DE AUTENTICACAO, de forma que
#                 seja dispensada a interacao com operador para os processos
#                 de transferencia de arquivos.
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis             Comentarios
# 20091006  Fabio Brito              Edicao original
#
# ------------------------------------------------------------------------- #


TPR="start"
. log

# Chamada de parametros para a Instancia
. SciELO.inc

# Recuperando nome da base de trabalho
#BASE=`pwd | cut -d"/" -f "3" | cut -d"." -f "1"`

BASE=$SIGLA2

echo
echo "Inicio: $0"
echo "Coleta de dados estatisticos / Bibliometria..."

cd ..
cd scibiblio/bases/estat/artigo
ONDE=`pwd`
echo "Agora em: $ONDE"

echo "Recuperando numero de registros v1^k de artigoc.iy0"
mx dict=run/artigoc "pft=v1^k/" now > tmp1
REGISTROS_ATIVOS=`tail -1 tmp1`
echo "registros: $REGISTROS_ATIVOS"

rm tmp1

# Data de ultima atualizacao
echo "Recuperando data da ultima atualizacao"
ARQ_IY0=`ls -l run/artigoc.iy0`
echo $ARQ_IY0

echo "Analisando data..."
# Verificacao da posicao da data em relacao a versao do LINUX
DATA_ANALISE=`echo $ARQ_IY0 | tr -s " " | cut -d" " -f "6"`
DATA_ANALISE1=`echo $DATA_ANALISE | cut -c5-5`


if [ "$DATA_ANALISE1" != "-" ]
then

# Trabalha a data no formato abaixo
#OFI2:/bases/lil.000/ado.lil> ls -l /bases/lil.000/ado.lil/ado.mst
#-rw-r--r--  1 cdrom cdrom 197783552 Aug 23 13:23 /bases/lil.000/ado.lil/ado.mst

        MES_MST=`echo $ARQ_IY0 | tr -s " " | cut -d" " -f "6"`
        DIA_MST=`echo $ARQ_IY0 | tr -s " " | cut -d" " -f "7"`

        if [ $DIA_MST -lt 10 ] #Formatando dia para 2 caracteres
        then
                DIA_MST="0$DIA_MST"
        fi

        HORA_MST=`echo $ARQ_IY0 | cut -d" " -f "8"`

        case $MES_MST in
                Jan) MES_MST=01;;
                Feb) MES_MST=02;;
                Mar) MES_MST=03;;
                Apr) MES_MST=04;;
                May) MES_MST=05;;
                Jun) MES_MST=06;;
                Jul) MES_MST=07;;
                Aug) MES_MST=08;;
                Sep) MES_MST=09;;
                Oct) MES_MST=10;;
                Nov) MES_MST=11;;
                Dec) MES_MST=12;;
        esac

        DOIS_PONTOS=`echo $HORA_MST | cut -c3-3` # Procura : na posicao da hora, se nao houver sera considerado ano

        if [ $DOIS_PONTOS != ":" ]
        then
                ANO=$HORA_MST
        else
                ANO="`date '+%Y'`"
        fi

else

# Trabalha a data no formato abaixo
#serverW:/home/bases/lil/ado.lil$ ls -l /home/bases/lil/ado.lil/ado.mst
#-rw-rw-r-- 1 cdrom apache 197783552 2009-08-23 13:46 /home/bases/lil/ado.lil/ado.mst


        ANO=`echo $DATA_ANALISE | cut -c1-4`
        MES_MST=`echo $DATA_ANALISE | cut -c6,6,7`
        DIA_MST=`echo $DATA_ANALISE | cut -c9,10`

fi

# Montando a data para MASTER
DT_MST="$ANO$MES_MST$DIA_MST"


# Recuperando tamanho da base - base.* - Em kbytes
du -s run/artigoc* | tr -s " " | cut -f1 > tamanho.seq
for  i in `cat tamanho.seq`;
do TOTBYTES=`expr ${TOTBYTES} + ${i}`; done;
rm tamanho.seq

# Transformando em megabytes
#TAMANHO=`expr "(${TOTBYTES} / 1024 ) / 1024" | bc -l` # em Giga
TAMANHO=`expr "${TOTBYTES} / 1024 " | bc -l` # em Mega
TAMANHO=`printf "%.2f\n" ${TAMANHO}`


echo "Recuperando duracao de processamento..."
## Entrada: TBIBLI como tempo em segundos
TBIBLI=`cat DURACAO.BIBLI.txt` # arquivo criado em Processa_SciELO

[ -z $TBIBLI ] && TBIBLI=0

MTPROC=`expr $TBIBLI % 3600`
HTPROC=`expr $TBIBLI - $MTPROC`
HTPROC=`expr $HTPROC / 3600`
STPROC=`expr $MTPROC % 60`
MTPROC=`expr $MTPROC - $STPROC`
MTPROC=`expr $MTPROC / 60`

THUMAN=`printf "%02d:%02d:%02d" $HTPROC $MTPROC $STPROC`

# Escrevendo XML
echo "Escrevendo XML..."
echo "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"                        >bibliometria_${BASE}.xml
echo " <INFO_SRC>"                                                           >>bibliometria_${BASE}.xml
echo "  <INFO_SRC_NAME FREQ=\"s\">bibliometria_${BASE}</INFO_SRC_NAME>"      >>bibliometria_${BASE}.xml
echo "  <REC_NUMBER>${REGISTROS_ATIVOS}</REC_NUMBER>"                        >>bibliometria_${BASE}.xml
echo "  <DISK_SPACE UNIT=\"Mbytes\">${TAMANHO}</DISK_SPACE>"                 >>bibliometria_${BASE}.xml
echo "  <LAST_UPDATE>${DT_MST}</LAST_UPDATE>"                                >>bibliometria_${BASE}.xml
echo "  <PROCESSING_TIME UNIT=\"human\">${THUMAN}</PROCESSING_TIME>"         >>bibliometria_${BASE}.xml
echo " </INFO_SRC>"                                                          >>bibliometria_${BASE}.xml


# Diretorio para reter dados historicos
NEWDIR=`date '+%Y%m'`


echo "Enviando bibliometria_${BASE}.xml para SERVEROFI..."
# ------------------------------------------------------------------------- #
echo "open serverofi.bireme.br"                           >cmd.ftp
echo "user cdrom cdru20f1"                               >>cmd.ftp
echo "cd /home/galvao/www/site/bvs/htdocs/docs/XMLs"     >>cmd.ftp
echo "put bibliometria_${BASE}.xml"                      >>cmd.ftp
echo "mkdir ${NEWDIR}"                                   >>cmd.ftp
echo "cd ${NEWDIR}"                                      >>cmd.ftp
echo "put bibliometria_${BASE}.xml"                      >>cmd.ftp
echo "bye"                                               >>cmd.ftp
ftp -i -v -n <cmd.ftp
rm cmd.ftp
# ------------------------------------------------------------------------- #


# Limpando area
rm bibliometria_${BASE}.xml
rm DURACAO.BIBLI.txt

# Passando para maiusculo
BASE=`echo ${BASE} | tr 'a-z' 'A-Z'`


# Emite relatorio texto
echo ""
#              1         2         3         4         5         6         7         8
#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "--------------------------------------------------------------------------------------"
echo "Relatorio de processamento $BASE/Bibliometria       (c)BIREME 2009          vrs: 1.0.2"
echo "OFI - Operacao de Fontes de Informacao           `date '+hr: %Hh%Mm%Ss  dt: %d/%m/%Y'`"
echo "--------------------------------------------------------------------------------------"
echo "         Total de postings base ${BASE} : ${REGISTROS_ATIVOS}"
echo "  Contagem de ocupacao de espaco(Mbytes): ${TAMANHO}"
echo "--------------------------------------------------------------------------------------"

# ------------------------------------------------------------------------- #
echo "Estatististica da base SciELO.${BASE}/Bibliometria  atualizada em `date '+hr: %Hh%Mm%Ss  dt: %d/%m/%Y'`" >mensagem.txt
echo "ServerOFI /home/galvao/www/site/bvs/htdocs/docs/XMLs"                                                   >>mensagem.txt
mail -s "Estatistica de SciELO.${BASE}/Bibliometria atualizada" ednilson.gesseff@scielo.org < mensagem.txt
rm mensagem.txt


echo "Voltando para /proc..."
cd ../../../../
cd proc
ONDE=`pwd`
echo "Agora em: $ONDE"

# scibiblio/bases/estat/artigo
echo "Termino: $0"


TPR="end"
. log
