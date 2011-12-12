
echo "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>" > input/$1.xml
echo "<recordset>" >> input/$1.xml

#cisis/mx $3/$2 gizmo=gizmo/stan_gentit  btell=0  "IV=$1$ and tp=h" "join=$3/iahlinks,200:2=v880" "proc='d32001'" lw=99999 pft=@pft/stanalyst_XML.pft -all now >> input/$1.xml

cisis/mx $3/$2 "proc=@prc/Article.prc" "proc='Ggizmo/stan_gentit'" "proc='Ggizmo/gcharSCL'" "btell=0" "tp=h and IV=${1}$" "proc='d32001'"  lw=99999 "pft=@pft/stan_stanalyst_XML.pft" -all now >> input/$1.xml

## cisis/mx ../bases/artigo/artigo "proc=@prc/Article.prc" "proc='Ggizmo/stan_en" "bool=tp=h and IV=S0001-3714$"

echo "</recordset>" >> input/$1.xml

# with XMLParser.jar
$JAVA_HOME/bin/java -jar java/XMLParser.jar xsl/stan_conversor_filter1.xslt input/$1.xml output/stanalyst_temp.xml
$JAVA_HOME/bin/java -jar java/XMLParser.jar xsl/stan_conversor_filter2.xslt output/stanalyst_temp.xml output/stan/$1.xml

# with SAXON
#time $JAVA_HOME/bin/java -jar java/saxon8.jar input/$1.xml xsl/stan_conversor_filter1.xslt > output/stanalyst_temp.xml
#time $JAVA_HOME/bin/java -jar java/saxon8.jar output/stanalyst_temp.xml xsl/stan_conversor_filter2.xslt > output/stan/$1.xml
rm output/stanalyst_temp.xml
