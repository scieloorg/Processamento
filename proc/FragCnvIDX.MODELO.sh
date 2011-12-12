# [flx_ProcessaSciELO.txt : 07] Prepara indices compactos
#
# O preparo deixa o diretorio o mais proximo possivel do que deve ser em producao
# Os direotrios ISSUE; NEWISSUE; IAH; e TITLE podem ser integralmente copiados
# Os diretorios LATTES; MEDLINE; e ARTIGO devem ser seletivamente copiados
#
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Compactacao de indices -- FragCnvIDX.${SIGLA2}.sh"
DIR_INIC=`pwd`

echo "Diretorio corrente: $DIR_INIC"
echo ""

#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Toma o tipo de Cochrane sendo executado
TYPSCI=`echo $LGPRD | cut -d "." -f "1"`

echo "Preparando indices compactos de:"
echo "-artigo"
cd ../bases/artigo
 if [ -f artigo.iy0 ]; then rm    artigo.iy0; fi
 if [ -f artigo.cnt ]; then mkiy0 artigo; fi
 if [ -f artigo.cnt ]; then rm    artigo.cnt artigo.iyp artigo.ly? artigo.n0?; fi
 if [ -f author.iy0 ]; then rm    author.iy0; fi
 if [ -f author.cnt ]; then mkiy0 author; fi
 if [ -f author.cnt ]; then rm    author.cnt author.iyp author.ly? author.n0?; fi

echo "-issue"
cd ../issue
 if [ -f faccount.iy0 ]; then rm    faccount.iy0; fi
 if [ -f faccount.cnt ]; then mkiy0 faccount; fi
 if [ -f faccount.cnt ]; then rm    faccount.cnt faccount.iyp faccount.ly? faccount.n0?; fi
 if [ -f facic.iy0 ];    then rm    facic.iy0; fi
 if [ -f facic.cnt ];    then mkiy0 facic; fi
 if [ -f facic.cnt ];    then rm    facic.cnt facic.iyp facic.ly? facic.n0?; fi
 if [ -f issue.iy0 ]; then rm    issue.iy0; fi
 if [ -f issue.cnt ]; then mkiy0 issue; fi
 if [ -f issue.cnt ]; then rm    issue.cnt issue.iyp issue.ly? issue.n0?; fi

echo "-newissue"
cd ../newissue
 if [ -f newissue.iy0 ]; then rm    newissue.iy0; fi
 if [ -f newissue.cnt ]; then mkiy0 newissue; fi
 if [ -f newissue.cnt ]; then rm    newissue.cnt newissue.iyp newissue.ly? newissue.n0?; fi

echo "-title"
cd ../title
 if [ -f logo.iy0 ]; then rm    logo.iy0; fi
 if [ -f logo.cnt ]; then mkiy0 logo; fi
 if [ -f logo.cnt ]; then rm    logo.cnt logo.iyp logo.ly? logo.n0?; fi
# [:INI:] Diferenca SciELO.BR x SciELO.XX - Nao ha necessidade de serarea ser transferido em SciELO.SP - Andre em 20070510
 if [ -f serareaEN.iy0 ]; then rm    serareaEN.iy0; fi
 if [ -f serareaEN.cnt ]; then mkiy0 serareaEN; fi
 if [ -f serareaEN.cnt ]; then rm    serareaEN.cnt serareaEN.iyp serareaEN.ly? serareaEN.n0?; fi
 if [ -f serareaES.iy0 ]; then rm    serareaES.iy0; fi
 if [ -f serareaES.cnt ]; then mkiy0 serareaES; fi
 if [ -f serareaES.cnt ]; then rm    serareaES.cnt serareaES.iyp serareaES.ly? serareaES.n0?; fi
 if [ -f serareaPT.iy0 ]; then rm    serareaPT.iy0; fi
 if [ -f serareaPT.cnt ]; then mkiy0 serareaPT; fi
 if [ -f serareaPT.cnt ]; then rm    serareaPT.cnt serareaPT.iyp serareaPT.ly? serareaPT.n0?; fi
# [:FIM:] Diferenca SciELO.BR x SciELO.XX - Nao ha necessidade de serarea ser transferido em SciELO.SP - Andre 20070510
 if [ -f title.iy0 ];   then rm    title.iy0; fi
 if [ -f title.cnt ];   then mkiy0 title; fi
 if [ -f title.cnt ];   then rm    title.cnt title.iyp title.ly? title.n0?; fi
 if [ -f titsrc.iy0 ];  then rm    titsrc.iy0; fi
 if [ -f titsrc.cnt ];  then mkiy0 titsrc; fi
 if [ -f titsrc.cnt ];  then rm    titsrc.cnt titsrc.iyp titsrc.ly? titsrc.n0?; fi
 if [ -f titsrcp.iy0 ]; then rm    titsrcp.iy0; fi
 if [ -f titsrcp.cnt ]; then mkiy0 titsrcp; fi
 if [ -f titsrcp.cnt ]; then rm    titsrcp.cnt titsrcp.iyp titsrcp.ly? titsrcp.n0?; fi

echo "-lattes"
cd ../lattes

echo "-medline"
cd ../medline

echo "-iah/..."
cd ../iah/library
export QTDDIR=`find .. * -type d | cut -d "/" -f "2" | grep -v "art.${TYPSCI}"  | wc -l`
export QTDDIR=`expr $QTDDIR - 1`
for i in `find .. * -type d | cut -d "/" -f "2" | grep -v "art.${TYPSCI}" | sort | tail -n "$QTDDIR"`
do
  echo "$i"
  cd ../$i
  if [ -f search.iy0 ];  then rm    search.iy0; fi
  if [ -f search.cnt ];  then mkiy0 search; fi
  if [ -f search.cnt ];  then rm    search.cnt search.iyp search.ly? search.n0?; fi
  if [ -f searchp.iy0 ]; then rm    searchp.iy0; fi
  if [ -f searchp.cnt ]; then mkiy0 searchp; fi
  if [ -f searchp.cnt ]; then rm    searchp.cnt searchp.iyp searchp.ly? searchp.n0?; fi

  if [ `basename $PWD` = "library" ]
  then
    for k in AfCid AfOrg AfPais AfPaisPais AfUfBr TipArt
    do
      echo $k
      if [ -f ${k}.iy0 ]; then rm    ${k}.iy0; fi
      if [ -f ${k}.cnt ]; then mkiy0 ${k}; fi
      if [ -f ${k}.cnt ]; then rm    ${k}.cnt ${k}.iyp ${k}.ly? ${k}.n0?; fi
    done
    for j in artscl_AG v667iahe v667iahi v667iahp
    do
      echo $j
      if [ -f ${j}.cnt ]; then rm    ${j}.cnt ${j}.iyp ${j}.ly? ${j}.n0?; fi
    done
  fi
done
unset QTDDIR

cd $DIR_INIC
unset DIR_INIC

echo "Diretorio corrente: `pwd`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Compactacao de indices -- FragCnvIDX.${SIGLA2}.sh"
