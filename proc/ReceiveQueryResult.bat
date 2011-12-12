export PATH=$PATH:.
export CISIS_DIR=cisis
INFORMALOG=log/ReceiveQueryResult.log

rem Este arquivo é uma chamada para o 
rem rem GenerateQueryProcess.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo ReceiveQueryResult.bat directory_of_incoming_data
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo ReceiveQueryResult
echo Inicializa variaveis
tdy=`date +%Y%m%d`

echo Inicializa variaveis

echo Verifica parametros


echo Prepara ambiente
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step3/
call batch/CriaDiretorio.bat ../bases-work/doi/receive_processed/
call batch/CriaDiretorio.bat ../bases-work/doi/receive_processed/$tdy
call batch/DeletaArquivo.bat temp/doi/step3/incoming_xml.seq
call batch/DeletaArquivo.bat temp/doi/step3/ReceiveQueryResult.bat
call batch/DeletaArquivo.bat temp/doi/step3/incoming_seq.seq
call batch/DeletaArquivo.bat temp/doi/step3/SetDOI.bat
call batch/DeletaArquivo.bat temp/doi/step3/SetDOI_2.bat

echo Get the incoming XML files
find ../bases-work/doi/receive/ -name '*.xml' > temp/doi/step3/incoming_xml.seq

echo Gera temp/doi/step3/ReceiveQueryResult.bat
cisis/mx seq=temp/doi/step3/incoming_xml.seq lw=9999 "pft='call batch/ReceiveQueryResult.bat ',v1,' ',replace(v1,'.xml','.list')/"  now >> temp/doi/step3/ReceiveQueryResult.bat

echo Executa temp/doi/step3/ReceiveQueryResult.bat
chmod 770 temp/doi/step3/ReceiveQueryResult.bat
call temp/doi/step3/ReceiveQueryResult.bat

echo Get the seq files resulting of temp/doi/step3/ReceiveQueryResult.bat
find ../bases-work/doi/receive/ -name '*.list' > temp/doi/step3/incoming_seq.seq

echo Gera temp/doi/step3/SetDOI.bat
cisis/mx seq=temp/doi/step3/incoming_seq.seq "pft='call batch/SetDOI.bat ',v1,/"  now >> temp/doi/step3/SetDOI.bat

echo Executa temp/doi/step3/SetDOI.bat
chmod 700 temp/doi/step3/SetDOI.bat
call temp/doi/step3/SetDOI.bat > temp/doi/step3/SetDOI_2.bat

echo Executa temp/doi/step3/SetDOI_2.bat
chmod 700 temp/doi/step3/SetDOI_2.bat
call temp/doi/step3/SetDOI_2.bat 

call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

mv ../bases-work/doi/receive/* ../bases-work/doi/receive_processed/$tdy
