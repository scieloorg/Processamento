echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envio de indices de afiliacao -- FragEnvHM2.${SIGLA2}.sh"

 scp ../bases/iah/library/AfCid.iy0    ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
 scp ../bases/iah/library/AfOrg.iy0    ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
 scp ../bases/iah/library/AfPais.iy0   ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
#scp ../bases/iah/library/AfUfBr.iy0   ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
 scp ../bases/iah/library/TipArt.iy0   ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
if [ $BIBLIOM ]
then
  scp ../bases/iah/library/v677iahe.iy0 ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
  scp ../bases/iah/library/v677iahi.iy0 ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
  scp ../bases/iah/library/v677iahp.iy0 ${HOMOL}:$PATH_BASES_HOMOLOG/iah/library
fi

if [ $SCIELOORG ]
then
  scp ../bases/iah/art.mod              ${HOMOL}:$PATH_BASES_HOMOLOG/iah/
fi

if [ $SCIMAGO ]
then
  scp -r ../bases/scimago               ${HOMOL}:$PATH_BASES_HOMOLOG/
fi

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envio de indices de afiliacao -- FragEnvHM2.${SIGLA2}.sh"
