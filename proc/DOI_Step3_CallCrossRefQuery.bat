export PATH=$PATH:.
export CISIS_DIR=cisis
export INFORMALOG=log/DOI_Step3_CallCrossRefQuery.log

rem Este arquivo é uma chamada para o 
rem rem DOI_Step3_CallCrossRefQuery.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo DOI_Step3_CallCrossRefQuery.bat directory_of_incoming_data
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo DOI_Step3_CallCrossRefQuery
echo Inicializa variaveis
tdy=`date +%Y%m%d`

echo Inicializa variaveis

echo Verifica parametros


echo Prepara ambiente
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step3_1/
call batch/CriaDiretorio.bat ../bases-work/doi/query_done/
call batch/CriaDiretorio.bat ../bases-work/doi/query_done/error
call batch/CriaDiretorio.bat ../bases-work/doi/query_done/warning
call batch/CriaDiretorio.bat ../bases-work/doi/query_done/success
call batch/CriaDiretorio.bat ../bases-work/doi/query_result/
call batch/CriaDiretorio.bat ../bases-work/doi/query_result/error
call batch/CriaDiretorio.bat ../bases-work/doi/query_result/warning
call batch/CriaDiretorio.bat ../bases-work/doi/query_result/success


call batch/DeletaArquivo.bat temp/doi/step3_1/query_list.seq
call batch/DeletaArquivo.bat crossref/CallCrossRefQuery.bat

echo Get the query files
find ../bases-work/doi/query/ -name '*.xml' > temp/doi/step3_1/query_list.seq

echo Gera crossref/CallCrossRefQuery.bat

cisis/mx seq=temp/doi/step3_1/query_list.seq lw=9999 "pft=@pft/doi_callCrossRefQuery.pft"  now >> crossref/CallCrossRefQuery.bat

echo Executa crossref/CallCrossRefQuery.bat
chmod 770 crossref/CallCrossRefQuery.bat
cd crossref
export PATH=$PATH:../.
export CISIS_DIR=../cisis
call CallCrossRefQuery.bat
cd ..

echo Fim de execucao de $0 $1 $2 $3 em `date`
