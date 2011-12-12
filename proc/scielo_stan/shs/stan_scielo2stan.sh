## Gera arquivo XML para Stanalyst

## Start Config vars
database_dir="/bases/scl.000/bases/artigo"
conversor_dir="/bases/scl.000/proc/scielo_stan/"
database_name="artigo"
## End Config vars

cd $conversor_dir

echo "Creating list"
  rm -f output/stan_list.txt
  rm -f stan_list.sh
  cisis/mx $database_dir/$database_name "proc=@proc/Article.prc" "btell=0" "tp=o" "lw=99999" "pft=mid(v880,1,10) #" -all now >> output/stan_list.txt
  sort -u output/stan_list.txt > output/stan_listDistinct.txt
  rm output/stan_list.txt
echo "issn list DONE!"


#COUNT=`wc -l output/stan_listDistinct.txt|cut -f1 -d" "`
COUNT=155
TOT=$COUNT

echo "TOTAL: "$COUNT
while [ $COUNT != 0 ]
do
     DAVEZ=`tail -$COUNT output/stan_listDistinct.txt | head -1`
    # echo "mkdir -p output/stan/$DAVEZ" >> stan_list.sh
     echo "shs/stan_geraXML.sh $DAVEZ $database_name $database_dir" >> shs/stan_list.sh
     echo "echo "`expr $TOT - $COUNT + 1 / $TOT`" done!" >> shs/stan_list.sh
     COUNT=`expr $COUNT - 1`
done

chmod 777 shs/stan_list.sh
echo "Starting run stan_list.sh"
shs/stan_list.sh

rm input/*.xml
rm output/stan_listDistinct.txt
rm output/stanalyst_temp.xml
