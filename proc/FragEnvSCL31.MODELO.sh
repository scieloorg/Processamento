# Transfere primeiro bloco de bases e indices para teste
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envio de resultados -- FragEnvSCL31.${SIGLA2}.sh"
export DIR_INIC=`pwd`
echo "Diretorio corrente: $PWD"
echo ""

echo "Transferencia da lista de controle de processamento"
scp scilista.lst ${TESTE}:$PATH_BASES_HOMOLOG

echo "Transferencia do dados do diretorio:"

echo "-artigo"
 scp ../bases/artigo/artigo.mst   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/artigo.xrf   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/artigo.iy0   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.cnt   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.iyp   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.ly?   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.n0?   ${TESTE}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/author.iy0   ${TESTE}:$PATH_BASES_HOMOLOG/artigo

echo "-issue"
scp -r ../bases/issue    ${TESTE}:$PATH_BASES_HOMOLOG

echo "-newissue"
scp -r ../bases/newissue ${TESTE}:$PATH_BASES_HOMOLOG

echo "-title"
scp -r ../bases/title ${TESTE}:$PATH_BASES_HOMOLOG

echo "-lattes"
scp -r ../bases/lattes/lattes.cnt ${TESTE}:$PATH_BASES_HOMOLOG/lattes/
scp -r ../bases/lattes/lattes.iyp ${TESTE}:$PATH_BASES_HOMOLOG/lattes/
scp -r ../bases/lattes/lattes.ly? ${TESTE}:$PATH_BASES_HOMOLOG/lattes/
scp -r ../bases/lattes/lattes.n0? ${TESTE}:$PATH_BASES_HOMOLOG/lattes/
scp -r ../bases/lattes/lattes.mst ${TESTE}:$PATH_BASES_HOMOLOG/lattes/
scp -r ../bases/lattes/lattes.xrf ${TESTE}:$PATH_BASES_HOMOLOG/lattes/

echo "-medline"
scp -r ../bases/medline/nlinks.cnt ${TESTE}:$PATH_BASES_HOMOLOG/medline/
scp -r ../bases/medline/nlinks.iyp ${TESTE}:$PATH_BASES_HOMOLOG/medline/
scp -r ../bases/medline/nlinks.ly? ${TESTE}:$PATH_BASES_HOMOLOG/medline/
scp -r ../bases/medline/nlinks.n0? ${TESTE}:$PATH_BASES_HOMOLOG/medline/
scp -r ../bases/medline/nlinks.mst ${TESTE}:$PATH_BASES_HOMOLOG/medline/
scp -r ../bases/medline/nlinks.xrf ${TESTE}:$PATH_BASES_HOMOLOG/medline/

echo "-iah/..."
scp -r ../bases/iah ${TESTE}:$PATH_BASES_HOMOLOG/

# Transferencia de DOI para teste
scp -r ../bases/doi/* ${TESTE}:$PATH_BASES_HOMOLOG/doi

cd $DIR_INIC
echo "Diretorio corrente: `pwd`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envio de resultados -- Frag EnvSCL31.${SIGLA2}.sh"
