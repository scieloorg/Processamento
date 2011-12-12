##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - PID que será formatado
#####

#####
# variáveis
. pubMedCentral_config.sh
##### 

echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > ../output/pubMedCentral/$1.xml
echo "<articles>" >> ../output/pubMedCentral/$1.xml

echo "Y.*="$database_title".*">../databases/pubMedCentral.cip

$cisis_dir/mx cipar=../databases/pubMedCentral.cip $database_article "proc=@../proc/Article.prc" "proc=('G../gizmo/pubMedCentral')" btell=0  "IV=$1$ and (tp=o or tp=h or tp=c or tp=r)" "proc='d32001'" lw=99999 pft=@../formats/pubMedCentral_XMLPubMed.pft -all now >> ../output/pubMedCentral/$1.xml

echo "</articles>" >> ../output/pubMedCentral/$1.xml
#rm pubMedCentral.cip
