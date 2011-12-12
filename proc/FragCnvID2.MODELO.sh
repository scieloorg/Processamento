echo "[TIMA-STAMP] `date '+%Y.%m%d %H:%M:%S'` [:INI:] Compacta indices de afiliacao -- FragCnvID2.${SIGLA2}.sh"

export DIR_INIC=`pwd`
echo "Preparando indices compactos de:"
echo "-iah/library"
cd ../bases/iah/library
for i in AfCid AfOrg AfPais AfUfBr AfPaisPais TipArt
do
  if [ -f ${i}.iy0 ]; then rm    ${i}.iy0; fi
  if [ -f ${i}.cnt ]; then mkiy0 ${i}; fi
  if [ -f ${i}.cnt ]; then rm    ${i}.cnt ${i}.iyp ${i}.ly? ${i}.n0?; fi
done

cd $DIR_INIC
unset DIR_INIC

echo "Diretorio corrente: `pwd`"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Compacta indices de afiliacao -- FragCnvID2.${SIGLA2}.sh"
