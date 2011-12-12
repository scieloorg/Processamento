# Transfere tambem a lista de controle de processamento - scilista.lst
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envio de resultados -- FragEnvHM1.${SIGLA2}.sh"

echo "Transferencia da lista de controle de processamento"
scp scilista.lst ${HOMOL}:$PATH_BASES_HOMOLOG

echo "Transferencia do dados do diretorio:"

echo "-artigo"
 scp ../bases/artigo/artigo.mst   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/artigo.xrf   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/artigo.iy0   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.cnt   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.iyp   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.ly?   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo.n0?   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo_*.mst ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
#scp ../bases/artigo/artigo_*.xrf ${HOMOL}:$PATH_BASES_HOMOLOG/artigo
 scp ../bases/artigo/author.iy0   ${HOMOL}:$PATH_BASES_HOMOLOG/artigo

echo "-issue"
scp -r ../bases/issue    ${HOMOL}:$PATH_BASES_HOMOLOG/

echo "-newissue"
scp -r ../bases/newissue ${HOMOL}:$PATH_BASES_HOMOLOG/

echo "-title"
scp -r ../bases/title    ${HOMOL}:$PATH_BASES_HOMOLOG/

echo "-lattes"
scp ../bases/lattes/lattes.cnt ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
scp ../bases/lattes/lattes.iyp ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
scp ../bases/lattes/lattes.ly? ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
scp ../bases/lattes/lattes.n0? ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
scp ../bases/lattes/lattes.mst ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
scp ../bases/lattes/lattes.xrf ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/

echo "-medline"
scp ../bases/medline/nlinks.cnt ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
scp ../bases/medline/nlinks.iyp ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
scp ../bases/medline/nlinks.ly? ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
scp ../bases/medline/nlinks.n0? ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
scp ../bases/medline/nlinks.mst ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
scp ../bases/medline/nlinks.xrf ${HOMOL}:$PATH_BASES_HOMOLOG/medline/

echo "-iah/..."
scp -r ../bases/iah ${HOMOL}:$PATH_BASES_HOMOLOG/

# Transferencia de DOI para homologacao
echo "-DOI"
   cp -r ../bases-work/doi ../bases/
# scp -r ../bases/doi ${HOMOL}:$PATH_BASES_HOMOLOG/

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envio de resultados -- FragEnvHM1.${SIGLA2}.sh"
