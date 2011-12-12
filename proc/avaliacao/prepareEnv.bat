export PATH=$PATH:.
rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem Prepara ambiente
rem ./avaliacao/prepareEnv.bat ../bases/title/title ../avaliacao/input/newcode ../bases/issue/issue ../bases/artigo/artigo XI 7/junho/2006 ../avaliacao/input/title_aux ../avaliacao/input/titlelist.txt 2006

rem prepareEnv
rem Parametro 1: title
rem Parametro 2: newcode
rem Parametro 3: issue
rem Parametro 4: artigo
rem Parametro 5: number of the meeting
rem Parametro 6: meeting date dia/mes/ano
rem Parametro 7: complemento da title
rem Parametro 8: selected titles list
rem Parametro 9: date


rem Inicializa variaveis
export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 title
call batch/VerifPresencaParametro.bat $0 @$2 newcode
call batch/VerifPresencaParametro.bat $0 @$3 issue
call batch/VerifPresencaParametro.bat $0 @$4 artigo

call batch/VerifPresencaParametro.bat $0 @$5 number of the meeting
call batch/VerifPresencaParametro.bat $0 @$6 meeting date

call batch/VerifPresencaParametro.bat $0 @$7 complemento title
call batch/VerifPresencaParametro.bat $0 @$8 selected titles list
call batch/VerifPresencaParametro.bat $0 @$9 date

export BASE_TITLE=$1
export BASE_NEWCODES=$2
export BASE_ISSUE=$3
export BASE_ARTICLE=$4
export NUMBER_MEETING=$5
export DATE_MEETING=$6
export NUMBER_MEETING=$5
export DATE_MEETING=$6
export BASE_TITLE_AUX_SEQ=$7
export SELECTED_TITLE_FILE=$8
export DATE_DIR=$9

export BASE_SORTED_ISSUE=temp/avaliacao/srtissue
export TEMP_TITLE=temp/avaliacao/title
export BASE_TITLE_AUX=temp/avaliacao/title_aux

export FORMAT_REPORT_LOCAL=../avaliacao/output/resumo/$9/ACRONIMO_resumo.htm
export INPUT_FOR_ENDO_REPORT_LOCAL=../avaliacao/output/endogenia/$9/ACRONIMO.xls

call batch/CriaDiretorio.bat temp
call batch/CriaDiretorio.bat temp/avaliacao
call batch/CriaDiretorio.bat ../avaliacao/output/

rem Uso de Formato
call batch/CriaDiretorio.bat ../avaliacao/output/resumo/
call batch/CriaDiretorio.bat ../avaliacao/output/resumo/$9

$CISIS_DIR/mx seq=$BASE_TITLE_AUX_SEQ.seq create=$BASE_TITLE_AUX now -all
$CISIS_DIR/mx $BASE_TITLE_AUX "fst=1 0 mpl,v9/" fullinv=$BASE_TITLE_AUX


rem Uso de Endogenia
call batch/CriaDiretorio.bat ../avaliacao/output/endogenia/
call batch/CriaDiretorio.bat ../avaliacao/output/endogenia/$9

$CISIS_DIR/mx $BASE_TITLE copy=$TEMP_TITLE now -all
$CISIS_DIR/mx $TEMP_TITLE fst=@fst/temp_title.fst fullinv=$TEMP_TITLE

rem Uso de Endogenia
$CISIS_DIR/mx null count=0 create=$BASE_SORTED_ISSUE
$CISIS_DIR/mx $BASE_ISSUE "proc=if p(v131) or p(v132) then 'd*' else 'd999a999{',f(1000 - val(v6),2,0),'{' fi" copy=$BASE_SORTED_ISSUE now -all
$CISIS_DIR/msrt $BASE_SORTED_ISSUE 20 v35,v999/
$CISIS_DIR/mx $BASE_SORTED_ISSUE "fst=1 0 mpl,v35,v999/" fullinv=$BASE_SORTED_ISSUE

./avaliacao/format/geraFormatReports.bat $SELECTED_TITLE_FILE $BASE_NEWCODES $NUMBER_MEETING $DATE_MEETING

./avaliacao/endogenia/geraInputForEndogeniaForSelectedTitles.bat $SELECTED_TITLE_FILE

