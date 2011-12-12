## Gera arquivo XML para Stanalyst

## Start Config vars
database_dir="/bases/scl.000/bases/artigo"
conversor_dir="/bases/scl.000/proc/scielo_stan/"
database_name="artigo"
## End Config vars

#cd $conversor_dir

echo "Creating list"
  rm -f output/stan_list.txt
  rm -f stan_list.sh
  cisis/mx $database_dir/$database_name "proc=@prc/Article.prc" "btell=0" "tp=o" "lw=99999" "pft=mid(v880,1,10) #" -all now >> output/stan_list.txt
  sort -u output/stan_list.txt > output/stan_listDistinct.txt
  rm output/stan_list.txt
echo "issn list DONE!"


COUNT=`grep -cE $ output/stan_listDistinct.txt`
TOT=$COUNT

echo "TOTAL: "$COUNT
while [ $COUNT != 0 ]
do
     DAVEZ=`tail -n $COUNT output/stan_listDistinct.txt | head -n 1`
    # echo "mkdir -p output/stan/$DAVEZ" >> stan_list.sh
     echo "./stan_geraXML.sh $DAVEZ $database_name $database_dir" >> stan_list.sh
     echo "echo "`expr $TOT - $COUNT + 1 / $TOT`" done!" >> stan_list.sh
     COUNT=`expr $COUNT - 1`
done

chmod 777 stan_list.sh
echo "Starting run stan_list.sh"
./stan_list.sh

#rm input/*.xml
#rm output/stan_listDistinct.txt
#rm output/stanalyst_temp.xml
