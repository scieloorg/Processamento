rem GeraInvertido
rem Parametro 1: base de dados
rem Parametro 2: fst 
rem Parametro 3: nome do invertido

#LC_ALL=POSIX

call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 fst
call batch/VerifPresencaParametro.bat $0 @$3 invertido a ser gerado
export INVBASE=$3

call batch/InformaLog.bat $0 x Gera invertido: $INVBASE

echo "Extrai chaves longas e curtas"
echo $1> temp/GeraInvertido.in
echo actab=tab/acanssci.tab >> temp/GeraInvertido.in
echo uctab=tab/ucanssci.tab >> temp/GeraInvertido.in
echo fst=@$2>> temp/GeraInvertido.in
echo ln1=$INVBASE.ln1>> temp/GeraInvertido.in
echo ln2=$INVBASE.ln2>> temp/GeraInvertido.in
echo +fix/m>> temp/GeraInvertido.in
echo -all>> temp/GeraInvertido.in
echo now>> temp/GeraInvertido.in
$CISIS_DIR/mx in=temp/GeraInvertido.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de chaves fst:@$2

call batch/sortT.bat $INVBASE.lk1 $INVBASE.ln1

call batch/sortT.bat $INVBASE.lk2 $INVBASE.ln2

$CISIS_DIR/iflind $INVBASE $INVBASE.lk1 $INVBASE.lk2 master=$1 +fix/m

 call batch/DeletaArquivo.bat $INVBASE.ln1
 call batch/DeletaArquivo.bat $INVBASE.ln2
 call batch/DeletaArquivo.bat $INVBASE.lk1
 call batch/DeletaArquivo.bat $INVBASE.lk2
