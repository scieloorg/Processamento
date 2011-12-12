echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envio de CITED, RELATED, e AREASGEO -- FragEnvHM3.${SIGLA2}.sh"

# CITED
  echo "  -transfere cited para SciELO.${SIGLA}"
  scp ../bases/cited/cited.* ${HOMOL}:$PATH_BASES_HOMOLOG/cited/

# RELATED
  echo "  -transfere related para SciELO.${SIGLA}"
  scp ../bases/related/related.* ${HOMOL}:$PATH_BASES_HOMOLOG/related/

# AREASGEO
if [ $AREAGEO ]
then
  echo "  -transfere areas geograficas para SciELO.${SIGLA}"
  scp ../bases/areasgeo/areasgeo.* ${HOMOL}:$PATH_BASES_HOMOLOG/areasgeo/
fi

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envio de CITED, RELATED, e AREASGEO -- FragEnvHM3.${SIGLA2}.sh"
