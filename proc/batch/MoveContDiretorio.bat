export PATH=$PATH:.
rem MovecontDiretorio
rem Parametro 1: diretorio com o conteudo a ser lido
rem Parametro 2: diretorio onde gravar o conteudo

call batch/VerifPresencaParametro.bat $0 @$1 diretorio a ser lido
call batch/VerifPresencaParametro.bat $0 @$2 diretorio a ser gravado

call batch/InformaLog.bat $0 x Copia Diretorio: $1 em: $2
if [ -d $1 ]
then
   mv $1 $2
else
   batch/AchouErro.bat $0 Diretorio nao encontrado: $1
fi
