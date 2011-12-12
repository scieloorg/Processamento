export PATH=$PATH:.
export CISIS_DIR=cisis
rem Este arquivo é uma chamada para o 
rem rem GenerateDOI_DB.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo GenerateDOI_DB.bat ..
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem GenerateDOI_DB
rem Parametro 1: path da producao da SciELO

rem Inicializa variaveis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 reset para zerar a base doi ou senao append 

call batch/CriaDiretorio.bat ../bases/doi
if [ ! -f "../bases/doi/doi.xrf" -o "$2" == "reset" ]
then
   echo "creating/reseting base doi..."
   call batch/CriaMaster.bat ../bases/doi/doi
   call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi
fi
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/step1/

call batch/DeletaArquivo.bat temp/doi/step1/doi.seq
call batch/DeletaArquivo.bat ../bases-work/doi/new_doi.xrf
call batch/DeletaArquivo.bat ../bases-work/doi/new_doi.mst

call batch/CriaDiretorio.bat ../bases-work/doi
call batch/CriaMaster.bat ../bases-work/doi/new_doi

echo create temp/doi/step1/doi.seq

cisis/mx ../bases/artigo/artigo "proc=@prc/Article.prc" btell=0 "bool=HR$ OR MDL=$" "pft=if l(['../bases/doi/doi'],v880)=0 then if v706='h' then  v880,'|art'/ else  v880,'|ref'/ fi,fi" now >> temp/doi/step1/doi.seq

echo doi.seq ready
echo creating db new_doi

cisis/mx seq=temp/doi/step1/doi.seq "proc=@prc/doi.prc" create=../bases-work/doi/new_doi now -all

echo new_doi db ready
echo Consolida os novos DOI aa base geral

call batch/AppendMaster.bat ../bases-work/doi/new_doi ../bases/doi/doi

echo Inverte a base DOIs consolidada

call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

echo Fim de execucao de $0 $1 $2 $3 em `date`
