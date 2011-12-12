# rem Garante inexistencia de arquivo flag
touch FLAG.txt
rm -f FLAG.txt

ITERACAO=0

while [ ! -s FLAG.txt ]
do

export ITERACAO=`expr $ITERACAO + 1`
echo "Executando pela ${ITERACAO}a. vez"

./GenerateQueryProcess.bat fjlopes@bireme.br 100

# rem Verifica a condicao de termino de execucao, resultado em FLAG.txt
cisis/mxf0 ../bases/doi/doi create=temp/doistat 0
cisis/mx temp/doistat "pft=(if v1020^t='002' then if val(v1009[1]) = val(v1020^d) then 'CHEGA' fi/,fi)" now > FLAG.txt

done

unset ITERACAO
