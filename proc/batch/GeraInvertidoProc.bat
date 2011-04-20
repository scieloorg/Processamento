rem GeraInvertidoProc
rem Parametro 1: base de dados
rem Parametro 2: fst 
rem Parametro 3: nome do invertido

echo "== Inversao de $1 com $2 gerando $3 == Chamada de $0 as: `date` ==">> /bases/scl.000/tinv.txt
call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 fst
call batch/VerifPresencaParametro.bat $0 @$3 invertido a ser gerado
export INVBASE=$3

call batch/InformaLog.bat $0 x Gera invertido: $INVBASE

INI_INV=`date +%s`
echo "### Inicio de inversao"

#echo "Extrai chaves longas e curtas"
echo $1> temp/GeraInvertido.in
echo proc=@prc/Artigo.prc>> temp/GeraInvertido.in
echo actab=tab/acanssci.tab >> temp/GeraInvertido.in
echo uctab=tab/ucanssci.tab >> temp/GeraInvertido.in
echo fst=@$2>> temp/GeraInvertido.in
echo ln1=$INVBASE.ln1>> temp/GeraInvertido.in
echo ln2=$INVBASE.ln2>> temp/GeraInvertido.in
echo +fix/m>> temp/GeraInvertido.in
echo -all>> temp/GeraInvertido.in
echo now>> temp/GeraInvertido.in
#COMECO=`date +%s`
#echo "Iniciando extracao aos: $COMECO[s]"
$CISIS_DIR/mx in=temp/GeraInvertido.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de chaves fst:@$2
#FINAL=`date +%s`
#echo "Concluindo extracao aos: $FINAL[s]"
#TOTAL=`expr $FINAL - $COMECO`
#echo "Tempo para extracao de chaves: $TOTAL [s]"
#echo "Tempo para extracao de chaves: $TOTAL [s]">> /bases/scl.000/tinv.txt
#echo ""

#COMECO=`date +%s`
#echo "Iniciando de ordenacao de chaves curtas aos: $COMECO[s]"
call batch/sortT.bat $INVBASE.lk1 $INVBASE.ln1
#FINAL=`date +%s`
#echo "Concluindo ordenacao de chaves curtas aos: $FINAL[s]"
#TOTAL=`expr $FINAL - $COMECO`
#echo "Tempo para ordenacao de chaves curtas: $TOTAL [s]"
#echo "Tempo para ordenacao de chaves curtas: $TOTAL [s]">> /bases/scl.000/tinv.txt
#echo ""

#COMECO=`date +%s`
#echo "Iniciando de ordenacao de chaves longas aos: $COMECO[s]"
call batch/sortT.bat $INVBASE.lk2 $INVBASE.ln2
#FINAL=`date +%s`
#echo "Concluindo ordenacao de chaves longas aos: $FINAL[s]"
#TOTAL=`expr $FINAL - $COMECO`
#echo "Tempo para ordenacao de chaves longas: $TOTAL [s]"
#echo "Tempo para ordenacao de chaves longas: $TOTAL [s]">> /bases/scl.000/tinv.txt
#echo ""

#COMECO=`date +%s`
#echo "Iniciando carga de invertido aos: $COMECO[s]"
#echo "$CISIS_DIR/iflind $INVBASE $INVBASE.lk1 $INVBASE.lk2 master=$1 +fix/m"
$CISIS_DIR/iflind $INVBASE $INVBASE.lk1 $INVBASE.lk2 master=$1 +fix/m
#FINAL=`date +%s`
#echo "Concluindo carga de invertido aos: $FINAL[s]"
#TOTAL=`expr $FINAL - $COMECO`
#echo "Tempo para carga de invertido: $TOTAL [s]"
#echo "Tempo para carga de invertido: $TOTAL [s]">> /bases/scl.000/tinv.txt
#echo ""

call batch/DeletaArquivo.bat $INVBASE.ln1
call batch/DeletaArquivo.bat $INVBASE.ln2
call batch/DeletaArquivo.bat $INVBASE.lk1
call batch/DeletaArquivo.bat $INVBASE.lk2
FIM_INV=`date +%s`
TOT_INV=`expr $FIM_INV - $INI_INV`
echo "Duracao total da inversao: $TOT_INV [s]"
#echo "Duracao total da inversao: $TOT_INV [s]">> /bases/scl.000/tinv.txt
echo "### Fim de inversao"
