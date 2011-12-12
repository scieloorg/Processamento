export PATH=$PATH:.
sed 's/<crossref_result.*>/<crossref_result>/g' $1 > temp/doi/step3/temp.xml
java -jar ./java/XMLParser.jar xsl/extractDOI.xsl temp/doi/step3/temp.xml $2