export PATH=$PATH:.
export CISIS_DIR=cisis
cisis/mx ../bases/doi/doi btell=0 lw=9000 "bool=STATUS=REQUESTED" "pft=proc('d2')"  copy=../bases/doi/doi now -all 
call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi
