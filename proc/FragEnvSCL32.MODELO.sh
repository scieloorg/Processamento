echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envio de indices de afiliacao -- FragEnvSCL32.${SIGLA2}.sh"

 scp ../bases/iah/library/AfCid.iy0    ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
 scp ../bases/iah/library/AfOrg.iy0    ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
#scp ../bases/iah/library/AfUfBr.iy0   ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
 scp ../bases/iah/library/TipArt.iy0   ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
if [ $BIBLIOM ]
then
  scp ../bases/iah/library/v677iahe.iy0 ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
  scp ../bases/iah/library/v677iahi.iy0 ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
  scp ../bases/iah/library/v677iahp.iy0 ${TESTE}:$PATH_BASES_HOMOLOG/iah/library
fi

if [ $SCIELOORG ]
then
  echo "Dados de SciELOpx1:/bases/${SIGLA3}.000/bases/iah/art.${SIGLA3}"
  scp -r ../bases/iah/art.${SIGLA3} ${TESTE}:$PATH_BASES_HOMOLOG/iah
fi

if [ $SCIMAGO ]
then
  scp -r ../bases/scimago               ${TESTE}:$PATH_BASES_HOMOLOG/
fi

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envio de indices de afiliacao -- FragEnvSCL32.${SIGLA2}.sh"
