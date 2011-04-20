rem GeraInvertidoProc
rem Parametro 1: base de dados
rem Parametro 2: fst 
rem Parametro 3: nome do invertido

call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 fst
call batch/VerifPresencaParametro.bat $0 @$3 invertido a ser gerado
export INVBASE=$3

call batch/InformaLog.bat $0 x Gera invertido: $INVBASE

echo $1> temp/GeraInvertido.in
echo proc=@prc/Artigo.prc>> temp/GeraInvertido.in
echo actab=tab/acanssci.tab >> temp/GeraInvertido.in
echo uctab=tab/ucanssci.tab >> temp/GeraInvertido.in
echo fst=@$2>> temp/GeraInvertido.in
echo fullinv/ansi=$INVBASE>> temp/GeraInvertido.in
$CISIS_DIR/mx in=temp/GeraInvertido.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de chaves fst:@$2

call batch/DeletaArquivo.bat $INVBASE.ln1
call batch/DeletaArquivo.bat $INVBASE.ln2
call batch/DeletaArquivo.bat $INVBASE.lk1
call batch/DeletaArquivo.bat $INVBASE.lk2
