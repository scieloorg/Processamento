#!/bin/bash
# export DEBUG=TRUE
# ------------------------------------------------------------------------- #
# StatSciELO.sh - Monta estatistica de processamento SciELO
# ------------------------------------------------------------------------- #
#     Entrada: parametro de definicao de SciELO em analise
#              Variavel de ambiente LATTES ajustada caso tenha CV-Lattes
#       Saida: relatorio na saida padrao com dados de registros e tamanhos
#              arquivo XML com dados de tempo de:
#                execucao;
#                quantidade de registros por tipo;
#                espaco em disco por diretorio.
#              emissao de e-mail avisando disponibilidade para lista OFI
#    Corrente: /bases/scl.???/proc
#     Chamada: ./StatSciELO <TYPE>
#     Exemplo: ./StatSciELO SP
#    Objetivo: Criar registro comprobatorio de operacao
# Observacoes: Ajustado para a configuracao do SciELO na BIREME
# ------------------------------------------------------------------------- #
#   Data    Resp                                 Comentario
# 20050608  MMB/FJL                 Edicao Original
# 20050609  FJLopes                 Ajuste no XML gerado
# 20051109  FJLopes                 Inclusao de relatorio de dados LATTES
# 20060607  FJLopes                 Adequacao a mudanca de tarefas e servidores
# 20060918  FJLopes                 Otimizacao de coleta de dados de espaco em disco
# 20070509  FJLopes                 Ajustes de atualizacao para novos servidores operados (PX1 e HM1)
# 20060510  FJLopes                 Correcao nos dados inserido no .seq de ScienTI
# 20091001  FLB/MMB/HB/FJL          Correcao na geracao da variavel REG_TOT
# 20100623  FLB/MMB/HB/FJL          Melhoria na contagem de registros
#

TPR="start"
. log

TREXE=$(basename $0)

# -------------------------------------------------------------------------- #
# Detecta e extrai opcao de chamada

unset OPCAO
OPTERR=0
# Neste exemplo soh avalia a opcao X, novas opcoes basta acrescentar na cadeia
while getopts 'tT' OPT_LETTER
do
        OPCAO=$OPT_LETTER
done

USED_UP=`expr $OPTIND - 1`
shift $USED_UP

echo ""

# Opcao informada eh desconhecida, mostrar a opcao
if [ ".$OPCAO" = ".?" ]; then
        TPR="fatal"
        MSG="SINTAXE: $TREXE [-T|t] <TYPE>  (-T causes not send XML frag to serverofi.bireme.br) <TYPE> SciELO Id"
        . log
        echo ""
fi

# A caixa nao nos interessa
OPCAO=`echo $OPCAO | tr [[:lower:]] [[:upper:]]`

# Aa saida o parametro 1 pode ser coletado como $1 normalmente e assim por diante

if [ $DEBUG ]; then
        echo "        ********************************************************"
        echo "[sh_ID] ** Chave de depuracao (\$DEBUG) esta ativa nesta execucao"
        echo "        ********************************************************"
fi

# ------------------------------------------------------------------------- #

#REM  12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "StatSciELO - Estatisticas de Processamento SciELO (c)2005-2010 vrs: 1.0 rel 07"
echo "BIREME/OPS/OMS                           SciELO                            OFI"
echo ""

#REM Avalia se recebeu o parametro obrigatorio
if [ $# -eq "0" ]; then
	echo "  Nao eh possivel efetuar o levantamento, falta parametro obrigatorio!"
	echo "  sintaxe: StatSciELO.sh [-X|x] <TYPE>"
	echo "     onde: TYPE = BR para SciELO - Brasil"
	echo "                = SP para SciELO - Saude Publica"
	echo "           -T   = bloqueia envio de fragmento de XML para serverofi"
	echo " exemplos: ./StatSciELO BR"
	echo "           ./StatSciELO -X SP"
	echo ""
	exit 1
fi

# ------------------------------------------------------------------------- #
# Torna explicito o efeito da opcao informada
echo "==========================================================="

echo "$TREXE processando SciELO.$1"
echo ""
if [ ".$OPCAO" = ".T" ]; then
        echo "= ATENCAO:  Fragmento XML NAO sera enviado para serverofi ="
else
        echo "= ATENCAO:  Fragmento XML     SERA enviado para serverofi ="
fi

echo "==========================================================="
echo ""

#REM CONTAGEM DE REGISTROS DA BASE DE DADOS
#REM Conta numero de registros tipo I - Issue
REG_I=`mx ../bases/artigo/artigo "TP=I"                                       count=1 "pft=/" now | tail -1 | cut -d"=" -f "2"`

#REM Conta numero de registros tipo H - Header
REG_H=`mx ../bases/artigo/artigo "TP=H"                                       count=1 "pft=/" now | tail -1 | cut -d"=" -f "2"`

#REM Conta numero de registros tipo L - Lilacs
REG_L=`mx ../bases/artigo/artigo "TP=L"                                       count=1 "pft=/" now | tail -1 | cut -d"=" -f "2"`

#REM Conta numero de registros tipo P - Paragraph
REG_P=`mx ../bases/artigo/artigo "TP=P"                                       count=1 "pft=/" now | tail -1 | cut -d"=" -f "2"`

#REM Conta numero de registros tipo C - Citation
REG_C=`mx ../bases/artigo/artigo "TP=C"                                       count=1 "pft=/" now|tail -1 | cut -d "=" -f "2"`

#REM Conta numero de registros tipo F, O e R - others
REG_FOR=`mx ../bases/artigo/artigo "TP=F+TP=O+TP=R"                           count=1 "pft=/" now | tail -1 | cut -d "=" -f "2"`

#REM Conta numero de registros de tipo valido
REG_TOTL=`mx ../bases/artigo/artigo "TP=F+TP=O+TP=R+TP=I+TP=H+TP=L+TP=P+TP=C" count=1 "pft=/" now | tail -1 | cut -d "=" -f "2"`

#REM Conta o numero de registros da base ARTIGO
mx ../bases/artigo/artigo +control count=0 now | tail -1 | tr -s " " > temp.seq
REG_TOT=`mx "seq=temp.seq " "pft=if v1>'' then v1 else v2 fi" now`
[ -f temp.seq ] && rm -f temp.seq
REG_TOT=`expr ${REG_TOT} - 1`


#REM Contabiliza espaco em disco utilizado
#REM Espaco utilizado pela TITLE
  TAM_TIT=`du -sh ../bases/title | cut -d "	" -f "1"`

#REM Espaco utilizado pela ISSUE
  TAM_ISS=`du -sh ../bases/issue | cut -d "	" -f "1"`

#REM Espaco utilizado pela NEWISSUE
  TAM_NEW=`du -sh ../bases/newissue | cut -d "	" -f "1"`

#REM Espaco utilizado pela ARTIGO
  TAM_ART=`du -sh ../bases/artigo | cut -d "	" -f "1"`

#REM Espaco utilizado com arquivos iAH
  TAM_IAH=`du -sh ../bases/iah | cut -d "	" -f "1"`

#REM Espaco utilizado com arquivos Lattes
  TAM_LAT=`du -sh ../bases/lattes |cut -d "	" -f "1"`

#REM Espaco utilizado com arquivos Medline
  TAM_MED=`du -sh ../bases/medline | cut -d "	" -f "1"`

# ------------------------------------------------------------------------- #
#REM Espaco total em disco
  TAM_TOT=`du -sm ../bases | cut -d "	" -f "1"`

#REM Contagens da Rede ScienTI
#REM Frequencia de processamento
echo "s"                                                                           > ScienTI-${1}.seq
if [ $LATTES ]; then
	#REM Autores
	cat temp/transf2lattes/SciELO.txt   | cut -d "|" -f "3" | sort -u | wc -l >> ScienTI-${1}.seq
	#REM Autores x Artigos
	wc -l temp/transf2lattes/SciELO.txt | cut -d " " -f "1"                   >> ScienTI-${1}.seq
	#REM Pesquisadores
	cat ../bases/lattes/lattes.seq      | cut -d "=" -f "2" | sort -u | wc -l >> ScienTI-${1}.seq
	#REM Pesquisadores x Artigos
	wc -l ../bases/lattes/lattes.seq    | cut -d " " -f "1"                   >> ScienTI-${1}.seq
else
	echo "0"                                                                  >> ScienTI-${1}.seq
	echo "0"                                                                  >> ScienTI-${1}.seq
	echo "0"                                                                  >> ScienTI-${1}.seq
	echo "0"                                                                  >> ScienTI-${1}.seq
fi
# REM Dia e Hora de atualizacao de dados
TIMEP=`date '+%H%M%S'`
DATEP=`date '+%Y%m%d'`

# REM Diretorio para reter dados historicos
NEWDIR=`date '+%Y%m'`

# REM Excluindo arquivos do processamento anterior
[ -f SciELO_REL_G.txt ] && rm SciELO_REL_G.txt
[ -f SciELO_REL.txt ] && rm SciELO_REL.txt
[ -f ScienTI-${1}.txt ] && rm ScienTI-${1}.txt

# REM Emite relatorio 1 em XML
echo "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"  > SciELO_REL_G.txt
echo "<SciELO INSTANCIA=\"${1}\">"                     >> SciELO_REL_G.txt
echo " <INSTANCIA>SciELO.${1}</INSTANCIA>"             >> SciELO_REL_G.txt
echo " <UPDATE_PROCESS_DATA>"                          >> SciELO_REL_G.txt
echo "  <REL_DATE TYPE=\"ISO\">${DATEP}</REL_DATE>"    >> SciELO_REL_G.txt
echo "  <REL_TIME>${TIMEP}</REL_TIME>"                 >> SciELO_REL_G.txt
echo "  <FREQUENCY>weekly</FREQUENCY>"                 >> SciELO_REL_G.txt
echo " </UPDATE_PROCESS_DATA>"                         >> SciELO_REL_G.txt
if [ -s duracao2.txt ]; then
	cat duracao2.txt                               >> SciELO_REL_G.txt
fi
echo " <RECORDS>"                                      >> SciELO_REL_G.txt
echo "  <REC_T>${REG_TOTL}</REC_T>"                    >> SciELO_REL_G.txt
echo "  <REC_I>${REG_I}</REC_I>"                       >> SciELO_REL_G.txt
echo "  <REC_H>${REG_H}</REC_H>"                       >> SciELO_REL_G.txt
echo "  <REC_L>${REG_L}</REC_L>"                       >> SciELO_REL_G.txt
echo "  <REC_P>${REG_P}</REC_P>"                       >> SciELO_REL_G.txt
echo "  <REC_C>${REG_C}</REC_C>"                       >> SciELO_REL_G.txt
echo "  <REC_FOR>${REG_FOR}</REC_FOR>"                 >> SciELO_REL_G.txt
echo "  <REC_TOT>${REG_TOT}</REC_TOT>"                 >> SciELO_REL_G.txt
echo " </RECORDS>"                                     >> SciELO_REL_G.txt
echo " <SPACE>"                                        >> SciELO_REL_G.txt
echo "  <SPC_TIT>${TAM_TIT}</SPC_TIT>"                 >> SciELO_REL_G.txt
echo "  <SPC_ISS>${TAM_ISS}</SPC_ISS>"                 >> SciELO_REL_G.txt
echo "  <SPC_NEW>${TAM_NEW}</SPC_NEW>"                 >> SciELO_REL_G.txt
echo "  <SPC_ART>${TAM_ART}</SPC_ART>"                 >> SciELO_REL_G.txt
echo "  <SPC_IAH>${TAM_IAH}</SPC_IAH>"                 >> SciELO_REL_G.txt
echo "  <SPC_LAT>${TAM_LAT}</SPC_LAT>"                 >> SciELO_REL_G.txt
echo "  <SPC_MED>${TAM_MED}</SPC_MED>"                 >> SciELO_REL_G.txt
echo "  <SPC_TOT UNIT=\"Mbytes\">${TAM_TOT}</SPC_TOT>" >> SciELO_REL_G.txt
echo " </SPACE>"                                       >> SciELO_REL_G.txt
echo "</SciELO>"                                       >> SciELO_REL_G.txt

# REM Emite relatorio 2 em XML
[ -z SciELO_REL.txt ] && rm -f SciELO_REL.txt
echo " <INFO_SRC>"                                             >> SciELO_REL.txt
echo "  <INFO_SRC_NAME FREQ=\"s\">SciELO.${1}</INFO_SRC_NAME>" >> SciELO_REL.txt
echo "  <REC_NUMBER>${REG_H}</REC_NUMBER>"                     >> SciELO_REL.txt
echo "  <DISK_SPACE UNIT=\"Mbytes\">${TAM_TOT}</DISK_SPACE>"   >> SciELO_REL.txt
if [ -s duracao.txt ]; then
	cat duracao.txt                                        >> SciELO_REL.txt
fi
echo "  <LAST_UPDATE>`date +%d/%m/%Y`</LAST_UPDATE>"           >> SciELO_REL.txt
echo " </INFO_SRC>"                                            >> SciELO_REL.txt

if [ $LATTES ]; then
	#REM Emite relatorio 3 (Rede ScienTI)
	[ -f ScienTI-${1}.txt ] && rm -f ScienTI-${1}.txt
	echo " <INFO_SRC>"                                                                    > ScienTI-${1}.txt
	echo "  <INFO_SRC_NAME FREQ=\"s\">ScienTI.Lattes</INFO_SRC_NAME>"                    >> ScienTI-${1}.txt
	echo     "  <AUTHORS>`head -2 ScienTI-${1}.seq | tail -1 | tr -d " "`</AUTHORS>"     >> ScienTI-${1}.txt
	echo "  <AUxARTICLES>`head -3 ScienTI-${1}.seq | tail -1 | tr -d " "`</AUxARTICLES>" >> ScienTI-${1}.txt
	echo "  <RESEARCHERS>`head -4 ScienTI-${1}.seq | tail -1 | tr -d " "`</RESEARCHERS>" >> ScienTI-${1}.txt
	echo "  <RExARTICLES>`head -5 ScienTI-${1}.seq | tail -1 | tr -d " "`</RExARTICLES>" >> ScienTI-${1}.txt
	echo "  <DISK_SPACE UNIT=\"Mbytes\">-</DISK_SPACE>"                                  >> ScienTI-${1}.txt
	echo "  <PROCESSING_TIME UNIT=\"human\">-</PROCESSING_TIME>"                         >> ScienTI-${1}.txt
	echo "  <LAST_UPDATE>`date +%d/%m/%Y`</LAST_UPDATE>"                                 >> ScienTI-${1}.txt
	echo " </INFO_SRC>"                                                                  >> ScienTI-${1}.txt
fi

# ------------------------------------------------------------------------- #
echo "open serverofi.bireme.br"                       > cmd.ftp
echo "user cdrom cdru20f1"                           >> cmd.ftp
echo "cd /home/galvao/www/site/bvs/htdocs/docs/XMLs" >> cmd.ftp
echo "put SciELO_REL_G.txt SciELO_REL_G.${1}.xml"    >> cmd.ftp
echo "put SciELO_REL.txt   SciELO_REL.${1}.xml"      >> cmd.ftp
if [ $LATTES ]; then
	echo "put ScienTI-${1}.txt ScienTI-${1}.xml" >> cmd.ftp
fi
echo "mkdir ${NEWDIR}"                               >> cmd.ftp
echo "cd ${NEWDIR}"                                  >> cmd.ftp
echo "put SciELO_REL_G.txt SciELO_REL_G.${1}.xml"    >> cmd.ftp
echo "put SciELO_REL.txt   SciELO_REL.${1}.xml"      >> cmd.ftp
if [ $LATTES ]; then
	echo "put ScienTI-${1}.txt ScienTI-${1}.xml" >>cmd.ftp
fi
echo "bye"                                           >> cmd.ftp
if [ ! $OPCAO ]; then
	ftp -i -v -n < cmd.ftp >> Relato.txt
fi
rm -f cmd.ftp

# ------------------------------------------------------------------------- #

# REM Emite relatorio texto
echo ""
#              1         2         3         4         5         6         7         8
#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "Relatorio de processamento SciELO.${1}       (c)BIREME 2005-2010     vrs: 1.1.0"
echo "OFI - Operacao de Fontes de Informacao          `date '+hr: %Hh%Mm%Ss  dt: %d/%m/%Y'`"
echo "-----------------------------------------------------------------------------"
echo " Contagem de registros por tipo"
echo "                                  Tipo de registro X Quantidade"
echo "             Registros tipo I (issue) no SciELO.${1}: ${REG_I}"
echo "            Registros tipo H (header) no SciELO.${1}: ${REG_H}"
echo "            Registros tipo L (LILACS) no SciELO.${1}: ${REG_L}"
echo "         Registros tipo P (paragraph) no SciELO.${1}: ${REG_P}"
echo "          Registros tipo C (citation) no SciELO.${1}: ${REG_C}"
echo "Registros de outros tipos (F; O; e R) no SciELO.${1}: ${REG_FOR}"
echo "==========================================================="
echo "           Total de registros da base do SciELO.${1}: ${REG_TOTL}"
echo "   Total de registros fisicos na base do SciELO.${1}: ${REG_TOT}"
echo ""
echo ""
echo " Contagem de ocupacao de espaco"
echo "                                          Elemento X Area"
echo "                  Espaco em disco usado pela TITLE: ${TAM_TIT}"
echo "                  Espaco em disco usado pela ISSUE: ${TAM_ISS}"
echo "               Espaco em disco usado pela NEWISSUE: ${TAM_NEW}"
echo "                 Espaco em disco usado pela ARTIGO: ${TAM_ART}"
echo "                    Espaco em disco usado pelo iAH: ${TAM_IAH}"
echo "                  Espaco em disco usado por Lattes: ${TAM_LAT}"
echo "                 Espaco em disco usado por Medline: ${TAM_MED}"
echo "             ============================================="
echo "                             Espaco em disco usado: ${TAM_TOT}"

# ------------------------------------------------------------------------- #
echo "Arquivo SciELO_REL.${1}.txt disponivel em"             > mensagem.txt
echo "ServerOFI /home/galvao/www/site/bvs/htdocs/docs/XMLs" >> mensagem.txt
if [ ! $OPCAO ]; then
	mail -s "Dados de SciELO.${1} gerados" ofi@bireme.org        < mensagem.txt
fi
rm -f mensagem.txt

TPR="end"
. log
