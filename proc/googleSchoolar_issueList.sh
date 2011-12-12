#####
# Gerador de lista de chamanda para o shell googleSchoolar_geraXML.sh
# Lista de Parametros
#####

# listar issn's validos	

cisis/mx ../bases/issue/issue "proc='s'" "pft=@pft/googleSchoolar_genListIssue.pft" now > issue.sh

# Previne inexistencia do diretorio dos resultados
if [ ! -d "output" ]
then
  mkdir -p output/googleSchoolar
fi

rm -rf output/googleSchoolar
mkdir output/googleSchoolar

echo "<HTML>" > output/googleSchoolar/index.htm
echo "<BODY>" >> output/googleSchoolar/index.htm

cisis/mx ../bases/issue/issue "proc='s'" "pft=@pft/googleSchoolar_genHTML.pft" now >> output/googleSchoolar/index.htm

echo "</BODY>" >> output/googleSchoolar/index.htm
echo "</HTML>" >> output/googleSchoolar/index.htm

chmod 755 issue.sh

./issue.sh

rm issue.sh
