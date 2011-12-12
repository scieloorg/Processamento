export PATH=$PATH:.
sed 's/<crossref_result.*>/<crossref_result>/g' $1 > temp/doi/step4/temp.xml
java -jar ./java/XMLParser.jar xsl/doi_extract_result.xsl temp/doi/step4/temp.xml $2
