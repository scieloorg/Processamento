export PATH=$PATH:.
rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem prepareEnv
rem Parametro 1: mx
rem Parametro 2: msrt
rem Parametro 3: title
rem Parametro 4: newcode
rem Parametro 5: issue
rem Parametro 6: artigo

rem Inicializa variaveis
export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 mx
call batch/VerifPresencaParametro.bat $0 @$2 msrt
call batch/VerifPresencaParametro.bat $0 @$3 title
call batch/VerifPresencaParametro.bat $0 @$4 newcode
call batch/VerifPresencaParametro.bat $0 @$5 issue
call batch/VerifPresencaParametro.bat $0 @$6 artigo


export MX=$1
export MSRT=$2
export BASE_TITLE=$3
export BASE_NEWCODES=$4
export BASE_ISSUE=$5
export BASE_ARTICLE=$6
export CISIS_DIR=cisis
export COUNT=3

call batch/CriaDiretorio.bat temp
call batch/CriaDiretorio.bat temp/avaliacao

export BASE_SORTED_ISSUE=temp/avaliacao/srtissue
export TEMP_TITLE=temp/avaliacao/title

rem geral

echo $CISIS_DIR
echo $BASE_TITLE

$CISIS_DIR/mx $BASE_TITLE copy=$TEMP_TITLE now -all
echo "$CISIS_DIR/mx $BASE_TITLE copy=$TEMP_TITLE now -all"
$CISIS_DIR/mx $TEMP_TITLE fst=@fst/temp_title.fst fullinv=$TEMP_TITLE

rem Uso de Endogenia
$CISIS_DIR/mx null count=0 create=$BASE_SORTED_ISSUE
$CISIS_DIR/mx $BASE_ISSUE "proc=if p(v131) or p(v132) then 'd*' else 'd999a999{',f(1000 - val(v6),2,0),'{' fi" copy=$BASE_SORTED_ISSUE now -all
$CISIS_DIR/msrt $BASE_SORTED_ISSUE 20 v35,v999/
$CISIS_DIR/mx $BASE_SORTED_ISSUE "fst=1 0 mpl,v35,v999/" fullinv=$BASE_SORTED_ISSUE

call avaliacao/teste2.bat  