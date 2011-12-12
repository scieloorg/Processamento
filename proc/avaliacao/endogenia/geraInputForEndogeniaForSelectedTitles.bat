rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem readInput
rem Parametro 1: file which content is acron or area or issn list

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 file which content is acron or area or issn list

export GERA_CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES=temp/avaliacao/geraCallInputForEndogeniaForSelectedTitles.bat
export CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES=temp/avaliacao/callInputForEndogeniaForSelectedTitles.bat

echo ''  > $GERA_CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES
echo ''  > $CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES

echo \'d9999a9999{$INPUT_FOR_ENDO_REPORT_LOCAL{a9001{$BASE_ARTICLE{\' > temp/avaliacao/endoSetParameters.prc

$CISIS_DIR/mx seq=$1 lw=999999  "proc='a9101{$CISIS_DIR{a9102{$TEMP_TITLE{a9103{$CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES{'" "pft=@avaliacao/endogenia/createCallMx.pft" now >> $GERA_CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES

chmod 775 $GERA_CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES
call $GERA_CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES

chmod 775 $CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES
call $CALL_INPUT_FOR_ENDO_FOR_SELECTED_TITLES

