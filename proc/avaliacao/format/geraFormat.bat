rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem geraFormat
rem Parametro 1: issn
rem Parametro 2: file
rem Parametro 3: newcode
rem Parametro 4: number of the meeting
rem Parametro 5: date of the meeting

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 issn
call batch/VerifPresencaParametro.bat $0 @$2 file
call batch/VerifPresencaParametro.bat $0 @$3 base newcodes
call batch/VerifPresencaParametro.bat $0 @$4 número da reunião
call batch/VerifPresencaParametro.bat $0 @$5 data da reunião

export CISIS_DIR=cisis
export BASE_TITLE_AUX=temp/avaliacao/title_aux
export TEMP_TITLE=temp/avaliacao/title

export BASE_NEWCODES=$3
export NUMBER_MEETING=$4
export DATE_MEETING="$5"

$CISIS_DIR/mx $TEMP_TITLE text=$1 tell=0 "proc='d7777d9999d9001d9002d7771a7777{$BASE_NEWCODES{a7771{$BASE_TITLE_AUX{a9999{$NUMBER_MEETING{a9001{',replace('$DATE_MEETING','/',' '),'{'" "proc=@avaliacao/format/format.prc" lw=999999 "pft=@avaliacao/format/format.pft" now> $2
