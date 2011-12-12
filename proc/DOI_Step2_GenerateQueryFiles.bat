export PATH=$PATH:.
export CISIS_DIR=cisis
export INFORMALOG=log/DOI_Step2_GenerateQueryFiles.log

rem Este arquivo é uma chamada para o 
rem rem DOI_Step2_GenerateQueryFiles.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo DOI_Step2_GenerateQueryFiles.bat senders_email 
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo DOI_Step2_GenerateQueryFiles

echo Inicializa variaveis
tdy=`date +%Y%m%d%H%M%S`
echo $2

echo Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 senders email 

echo Prepara ambiente
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step2/
call batch/CriaDiretorio.bat ../bases-work/doi/query/
call batch/DeletaArquivo.bat temp/doi/step2/SelectedRecordsToQuery.seq
call batch/DeletaArquivo.bat temp/doi/step2/DOI_Step2_GenerateQueryXML.bat

chmod 777 ../bases/doi/doi.*

echo Gera temp/doi/step2/DOI_Step2_GenerateQueryXML.bat
cisis/mx ../bases/doi/doi btell=0 lw=9000 "bool=(STATUS= or STATUS=NOT_FOUND)" "pft='call batch/DOI_Step2_GenerateQueryXML.bat ',v880,' $1' /" "proc='d2a2{requested^d',date,'{'" copy=../bases/doi/doi now -all >> temp/doi/step2/DOI_Step2_GenerateQueryXML.bat
call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

echo Execute temp/doi/step2/DOI_Step2_GenerateQueryXML.bat
chmod 770 temp/doi/step2/DOI_Step2_GenerateQueryXML.bat
call temp/doi/step2/DOI_Step2_GenerateQueryXML.bat

echo Fim de execucao de $0 $1 $2 $3 em `date`
