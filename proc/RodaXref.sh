# TEMPORARIAMENTE RETIRADO DO FLUXO DE SCIELO - 20070514
# [flx_ProcessaSciELO.txt : 05] Executa procedimento de Xref opera artigos
# ATENCAO: Mensagens capturadas em arquivo especifico de xref
# echo "Requisicao de DOI para Crossref"
# cd scielo_crs/shs/
# ./crossref_run.sh >& ../../outs/xref`date '+%Y%m%d'`
# cd -

# [flx_ProcessaSciELO.txt : 05a] Executa procedimento de Query ao Xref para artigos
# ATENCAO: Mensagens capturadas em arquivo especifico de xref
echo "Query de DOI para Crossref"

doi/create/doi4art.bat lista/scilista.lst log/QueryXref.log >& ../../outs/qxref`date '+%Y%m%d'`
# mv lista/nxt.scilista.lst lista/scilista.lst

