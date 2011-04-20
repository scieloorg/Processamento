export PATH=$PATH:.
export CISIS_DIR=cisis
rem Este arquivo é uma chamada para o 
rem batch/GenerateDOI_Query.bat

rem echo === ATENCAO ===
rem echo 
rem echo Este arquivo executara o seguinte comando
rem echo batch/GenerateDOI_Query.bat base_artigo
rem echo 
rem echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem batch/GenerateDOI_Query
rem Parametro 1: base artigo

rem Inicializa variaveis
rem arquivo=`date +%Y%m%d%H%M%S`
tdy=`date +%Y%m%d%H%M%S`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 arquivo_xml
call batch/VerifPresencaParametro.bat $0 @$2 e-mail
call batch/VerifPresencaParametro.bat $0 @$3 pid


call batch/DeletaArquivo.bat ../bases-work/doi/query/$1

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > ../bases-work/doi/query/$1
echo "<query_batch version=\"2.0\" xmlns=\"http://www.crossref.org/qschema/2.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" >> ../bases-work/doi/query/$1
echo "<head>" >> ../bases-work/doi/query/$1
echo "<email_address>$2</email_address>" >> ../bases-work/doi/query/$1
echo "<doi_batch_id>scielo_$tdy</doi_batch_id>" >> ../bases-work/doi/query/$1
echo "</head>" >> ../bases-work/doi/query/$1
echo "<body>" >> ../bases-work/doi/query/$1

cisis/mx ../bases/artigo/artigo gizmo=gizmo/win2ent btell=0 lw=99999 "R=$3 or HR=$3" "proc=@prc/Article.prc" "pft=@doi/pft/doi_query.pft" now >> ../bases-work/doi/query/$1

echo \</body\> >> ../bases-work/doi/query/$1
echo \</query_batch\> >> ../bases-work/doi/query/$1



