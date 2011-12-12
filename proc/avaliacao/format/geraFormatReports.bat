rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem readInput
rem Parametro 1: file which content is acron or area or issn list
rem Parametro 2: arquivo seq com dados complementares de title 
rem Parametro 3: newcode
rem Parametro 4: number of the meeting
rem Parametro 5: date of the meeting

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 file which content is acron or area or issn list
call batch/VerifPresencaParametro.bat $0 @$2 base newcodes
call batch/VerifPresencaParametro.bat $0 @$3 número da reunião
call batch/VerifPresencaParametro.bat $0 @$4 data da reunião

export CISIS_DIR=cisis

export BASE_NEWCODES=$2
export NUMBER_MEETING=$3
export DATE_MEETING=$4

export GERA_CALL_FORMAT_FOR_SELECTED_TITLES=temp/avaliacao/geraCallFormatForSelectedTitles.bat
export CALL_FORMAT_FOR_SELECTED_TITLES=temp/avaliacao/callFormatForSelectedTitles.bat

echo '' > $GERA_CALL_FORMAT_FOR_SELECTED_TITLES
echo '' > $CALL_FORMAT_FOR_SELECTED_TITLES

echo \'d9999a9999{$FORMAT_REPORT_LOCAL{a9001{$BASE_NEWCODES{a9002{$NUMBER_MEETING{a9003{$DATE_MEETING{\' > temp/avaliacao/formatSetParameters.prc

$CISIS_DIR/mx seq=$1 lw=999999  "proc='a9101{$CISIS_DIR{a9102{$TEMP_TITLE{a9103{$CALL_FORMAT_FOR_SELECTED_TITLES{'" "pft=@avaliacao/format/createCallMx.pft" now >> $GERA_CALL_FORMAT_FOR_SELECTED_TITLES

chmod 775 $GERA_CALL_FORMAT_FOR_SELECTED_TITLES
$GERA_CALL_FORMAT_FOR_SELECTED_TITLES

chmod 775 $CALL_FORMAT_FOR_SELECTED_TITLES
$CALL_FORMAT_FOR_SELECTED_TITLES
