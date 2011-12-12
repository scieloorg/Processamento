export PATH=$PATH:.
rem Envia2SciELOSPOnline
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo de logOn FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/Envia2SciELOSPOnline.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path da producao da SciELOSP
call batch/VerifPresencaParametro.bat $0 @$2 arquivo de logOn FTP
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CriaTGZBases.bat $1 temp/transf2public

rem Gera arquivo de parametros do FTP
call batch/CopiaArquivo.bat $2 temp/EnviaTGZBases.txt

echo lcd temp/transf2public>> temp/EnviaTGZBases.txt
echo cd InBox >> temp/EnviaTGZBases.txt
echo put bases2publish.tgz >>temp/EnviaTGZBases.txt
echo bye >> temp/EnviaTGZBases.txt

call batch/InformaLog.bat $0 x FTP das bases
ftp -n <temp/EnviaTGZBases.txt >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: temp/EnviaTGZBases.txt

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

