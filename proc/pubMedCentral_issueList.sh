#####
# Gerador de lista de chamanda para o shell pubMedCentral_geraXML.sh
# Lista de Parametros
#####
#####
# variaveis
. pubMedCentral_config.sh
#####

# listar issn's validos	

cisis/mx $database_issue "proc='s'" "pft=@pft/pubMedCentral_genListIssue.pft" now > issue.sh

# Previne inexistencia do diretorio dos resultados
if [ ! -d "output" ]
then
  mkdir -p output/pubMedCentral
fi

rm output/pubMedCentral/*

echo "<HTML>" > output/pubMedCentral/index.htm
echo "<BODY>" >> output/pubMedCentral/index.htm

cisis/mx $database_issue "proc='s'" "pft=@pft/pubMedCentral_genHTML.pft" now >> output/pubMedCentral/index.htm

echo "</BODY>" >> output/pubMedCentral/index.htm
echo "</HTML>" >> output/pubMedCentral/index.htm

chmod 755 issue.sh

./issue.sh

rm issue.sh
