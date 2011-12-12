export PATH=$PATH:.
export CISIS_DIR=cisis
export INFORMALOG=log/DOI_Step4_ReceiveQueryResult.log


rem Este arquivo é uma chamada para o 
rem rem GenerateQueryProcess.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo DOI_Step4_ReceiveQueryResult.bat directory_of_incoming_data
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo DOI_Step4_ReceiveQueryResult
echo Inicializa variaveis
tdy=`date +%Y%m%d`

echo Inicializa variaveis

echo Verifica parametros


echo Prepara ambiente
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step4/
call batch/CriaDiretorio.bat ../bases-work/doi/receive_processed/
call batch/CriaDiretorio.bat ../bases-work/doi/receive_processed/$tdy
call batch/DeletaArquivo.bat temp/doi/step4/incoming_xml.seq
call batch/DeletaArquivo.bat temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat
call batch/DeletaArquivo.bat temp/doi/step4/incoming_seq.seq
call batch/DeletaArquivo.bat temp/doi/step4/temp/doi/step4/SetDOI.bat
call batch/DeletaArquivo.bat temp/doi/step4/temp/doi/step4/SetDOI_2.bat

echo Get the incoming XML files
find ../bases-work/doi/query_result/success/ -name '*.xml' > temp/doi/step4/incoming_xml.seq

echo Gera temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat
cisis/mx seq=temp/doi/step4/incoming_xml.seq lw=9999 "pft='call batch/DOI_Step4_ExtractResultFromXML.bat ',v1,' ',replace(v1,'.xml','.list')/"  now >> temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat

echo Executa temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat
chmod 770 temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat
call temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat

echo Get the seq files resulting of temp/doi/step4/DOI_Step4_ReceiveQueryResult.bat
find ../bases-work/doi/query_result/success/ -name '*.list' > temp/doi/step4/incoming_seq.seq

echo Gera temp/doi/step4/SetDOI.bat
cisis/mx seq=temp/doi/step4/incoming_seq.seq lw=9999 "pft='cisis/mx seq=',v1,' lw=99999 pft=@pft/doi_set.pft now'/"  now >> temp/doi/step4/SetDOI.bat

echo Executa temp/doi/step4/SetDOI.bat
chmod 700 temp/doi/step4/SetDOI.bat
call temp/doi/step4/SetDOI.bat > temp/doi/step4/SetDOI_2.bat

echo Executa temp/doi/step4/SetDOI_2.bat
chmod 700 temp/doi/step4/SetDOI_2.bat
call temp/doi/step4/SetDOI_2.bat 

call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

mv ../bases-work/doi/query_result/success/* ../bases-work/doi/receive_processed/$tdy
