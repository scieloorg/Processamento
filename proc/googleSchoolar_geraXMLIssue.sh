##### 
# Gera arquivo XML da bases scielo FRONT/BACK
# Parametros
# $1 - nome da base de dados que será processada


echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > output/googleSchoolar/$1.xml
echo "<articles>" >> output/googleSchoolar/$1.xml

echo "Y.*=../bases/title/title.*">google.cip

cisis/mx cipar=google.cip ../bases/artigo/artigo "proc=@prc/Article.prc" "proc=('Ggizmo/googleSchoolar')" btell=0  "IV=$1$ and (tp=o or tp=h or tp=c or tp=r)" "proc='d32001'" lw=99999 pft=@pft/googleSchoolar_XMLPubMed.pft -all now >> output/googleSchoolar/$1.xml

echo "</articles>" >> output/googleSchoolar/$1.xml
rm google.cip
