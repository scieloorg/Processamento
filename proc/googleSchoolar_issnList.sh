#####
# Gerador de lista de chamanda para o shell googleSchoolar_geraXML.sh
# Lista de Parametros
#####

# listar issn's validos
cisis/mx ../bases/title/title "proc='s'" "pft=@pft/googleSchoolar_genList.pft" now > issn.sh

# Previne inexistencia do diretorio dos resultados
if [ ! -d "output" ]
then
  mkdir -f output/googleSchoolar
fi

rm output/googleSchoolar/*

echo "<HTML>" > output/googleSchoolar/index.htm
echo "<BODY>" >> output/googleSchoolar/index.htm

cisis/mx ../bases/title/title "proc='s'" "pft=@pft/googleSchoolar_genHTML.pft" now >> output/googleSchoolar/index.htm

echo "</BODY>" >> output/googleSchoolar/index.htm
echo "</HTML>" >> output/googleSchoolar/index.htm

chmod 755 issn.sh
./issn.sh

rm issn.sh
