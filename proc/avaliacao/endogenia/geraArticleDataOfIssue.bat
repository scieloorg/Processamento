rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem geraFormat
rem Parametro 1: mfn of sorted issue
rem Parametro 2: issn_id
rem Parametro 3: output
rem Parametro 4: base article

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 mfn of sorted issue
call batch/VerifPresencaParametro.bat $0 @$2 issn_id
call batch/VerifPresencaParametro.bat $0 @$3 output
call batch/VerifPresencaParametro.bat $0 @$4 base article



export BASE_ARTICLE=$4
export INPUT_FILE_FOR_ENDO=$3
export BASE_SORTED_ISSUE=temp/avaliacao/srtissue

rem $CISIS_DIR/mx $BASE_SORTED_ISSUE from=$1 count=1 lw=99999  "pft=@avaliacao/endogenia/xls_issueheader.pft" now  >> $INPUT_FILE_FOR_ENDO 

call batch/DeletaArquivo.bat temp/avaliacao/aff.mst
call batch/DeletaArquivo.bat temp/avaliacao/aff.xrf

$CISIS_DIR/mx $BASE_ARTICLE "proc=@prc/Article.prc" btell=0 "bool=HR=$2$" lw=99999 "pft=(v880[1],'|',v70/)" now > temp/avaliacao/aff.seq

$CISIS_DIR/mx seq=temp/avaliacao/aff.seq create=temp/avaliacao/aff now -all
$CISIS_DIR/mx temp/avaliacao/aff "fst=1 0 mpl,v1,v2^i/" fullinv=temp/avaliacao/aff


$CISIS_DIR/mx $BASE_ARTICLE "proc=@prc/Article.prc" btell=0 "bool=HR=$2$" lw=99999 "pft=@avaliacao/endogenia/xls_getArticleData.pft" now >> $INPUT_FILE_FOR_ENDO 

echo $CISIS_DIR/mx $BASE_ARTICLE "proc=@prc/Article.prc" btell=0 "bool=HR=$2$" lw=99999 "pft=@avaliacao/endogenia/xls_getArticleData.pft" 
