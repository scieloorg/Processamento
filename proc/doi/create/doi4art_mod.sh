doi/create/doi4art.bat criDoi.lst log/QueryXref.log

echo ""
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:INI:] Copiando base DOI"
echo "cp -r ../bases-work/doi/* ../bases/doi"
      cp -r ../bases-work/doi/* ../bases/doi
     scp -r ../bases-work/doi/* $TESTE:/home/scieloXX/www/bases/doi
     scp -r ../bases-work/doi/* $TESTE:/home/scieloXX/www/bases-work/doi
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:FIM:] Copiando base DOI"
echo ""
