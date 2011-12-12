export PATH=$PATH:.
export CISIS_DIR=cisis
INFORMALOG=log/GenerateQueryProcess.log

rem Este arquivo é uma chamada para o 
rem rem GenerateQueryProcess.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo GenerateQueryProcess.bat senders_email quantidade_de_queries
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo GenerateQueryProcess

echo Inicializa variaveis
tdy=`date +%Y%m%d%H%M%S`
echo $2

echo Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 senders email 
call batch/VerifPresencaParametro.bat $0 @$2 quantidade de queries

echo Prepara ambiente
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step2/
call batch/CriaDiretorio.bat ../bases-work/doi/query/
call batch/DeletaArquivo.bat temp/doi/step2/SelectedRecordsToQuery.seq
call batch/DeletaArquivo.bat temp/doi/step2/SelectBasesArtigoExistentesQue.bat
call batch/DeletaArquivo.bat temp/doi/step2/bases_artigo_existentes_query.seq
call batch/DeletaArquivo.bat temp/doi/step2/GenerateDOI_Query.bat
call batch/DeletaArquivo.bat ../bases-work/doi/query/DOI_Query_$tdy.xml
chmod 777 ../bases/doi/doi.*

echo Select the records to query
cisis/mx ../bases/doi/doi btell=0 lw=9000 "bool=(STATUS= or STATUS=NOT_FOUND)" "pft=v880/,proc('d2a2{requested^d',date,'{')" count=$2 copy=../bases/doi/doi now -all >> temp/doi/step2/SelectedRecordsToQuery.seq
call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

echo Gera temp/doi/step2/GenerateDOI_Query.bat
cisis/mx seq=temp/doi/step2/SelectedRecordsToQuery.seq lw=9000 "pft='call batch/GenerateDOI_Query.bat ',v1/" now -all>> temp/doi/step2/GenerateDOI_Query.bat

echo Gera ../bases-work/doi/query/DOI_Query_$tdy.xml
chmod 700 temp/doi/step2/GenerateDOI_Query.bat

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "<query_batch version=\"2.0\" xmlns=\"http://www.crossref.org/qschema/2.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "<head>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "<email_address>$1</email_address>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "<doi_batch_id>scielo_$tdy</doi_batch_id>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "</head>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo "<body>" >> ../bases-work/doi/query/DOI_Query_$tdy.xml

call temp/doi/step2/GenerateDOI_Query.bat >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo \</body\> >> ../bases-work/doi/query/DOI_Query_$tdy.xml
echo \</query_batch\> >> ../bases-work/doi/query/DOI_Query_$tdy.xml

