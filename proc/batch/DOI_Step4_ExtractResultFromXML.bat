export PATH=$PATH:.
sed 's/<crossref_result.*>/<crossref_result>/g' $1 > temp/doi/step4/temp.xml
java -jar java/saxon8.jar -o $2 temp/doi/step4/temp.xml doi/xsl/doi_extract_result.xsl