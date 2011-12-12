##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - PID que será formatado
#####

#####
# variáveis
. pubMedCentral_config.sh
##### 

echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > output/pubMedCentral/$1.xml
echo "<articles>" >> output/pubMedCentral/$1.xml

echo "Y.*="$database_title".*">pubMedCentral.cip

$cisis_dir/mx cipar=pubMedCentral.cip $database_article "proc=@prc/Article.prc" "proc=('Ggizmo/pubMedCentral')" btell=0  "IV=$1$ and (tp=o or tp=h or tp=c or tp=r)" "proc='d32001'" lw=99999 pft=@pft/pubMedCentral_XMLPubMed.pft -all now >> output/pubMedCentral/$1.xml

echo "</articles>" >> output/pubMedCentral/$1.xml
#rm pubMedCentral.cip
