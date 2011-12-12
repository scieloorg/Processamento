export PATH=$PATH:.
export CISIS_DIR=cisis
export INFORMALOG=log/DOI_Tool_SetDOIArticle.log

cisis/mx ../bases/doi/doi btell=0 "bool=TYPE=ART and DOI=" "proc=@prc/doi_add2art.prc" copy=../bases/doi/doi now -all
call batch/GeraInvertido.bat ../bases/doi/doi fst/doi.fst ../bases/doi/doi

