rem CriaTGZBases
rem Parametro 1: path da producao
rem Parametro 2: diretorio dos arquivos tgz

call batch/VerifPresencaParametro.bat $0 @$1 caminho do diretorio raiz da producao
call batch/VerifPresencaParametro.bat $0 @$2 diretorio dos arquivos tgz
call batch/CriaDiretorio.bat $2
call batch/InformaLog.bat $0 x Cria tgz-bases: $1 em $2

cd $1
tar cvfzp $1/proc/$2/bases2publish.tgz --files-from=$1/proc/listas/lista-arquivos-bases.txt
cd $1/proc
