rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem geraFormat
rem Parametro 1: issn
rem Parametro 2: file
rem Parametro 3: base article 

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 issn
call batch/VerifPresencaParametro.bat $0 @$2 file
call batch/VerifPresencaParametro.bat $0 @$3 base article

export INPUT_FILE_FOR_ENDO=$2 
export BASE_ARTICLE=$3 
export BASE_SORTED_ISSUE=temp/avaliacao/srtissue
export TEMP_TITLE=temp/avaliacao/title
export COUNT=3

$CISIS_DIR/mx $TEMP_TITLE text=$1  tell=0  lw=99999  "pft=@avaliacao/endogenia/xls_header.pft" now > $2

$CISIS_DIR/mx $BASE_SORTED_ISSUE btell=0 "bool=$1$" count=1 "pft=''" now > temp/avaliacao/callGeraArticleDataOfIssue.bat
$CISIS_DIR/mx $BASE_SORTED_ISSUE btell=0 "bool=$1$" count=$COUNT lw=99999 "proc='a9001{$INPUT_FILE_FOR_ENDO{a9002{$BASE_ARTICLE{" "pft=@avaliacao/endogenia/callGeraArticleDataOfIssue.pft" now >> temp/avaliacao/callGeraArticleDataOfIssue.bat
call temp/avaliacao/callGeraArticleDataOfIssue.bat
$CISIS_DIR/mx $TEMP_TITLE text=$1 lw=99999  "pft=@avaliacao/endogenia/xls_foot.pft" now >> $2
