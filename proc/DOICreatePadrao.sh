# ------------------------------------------------------------------------- #
# DOICreatePadrao - Dispara o processo de solicitacao de DOI
# ------------------------------------------------------------------------- #
#     Entrada : Nenhuma
#       Saida :  Nenhuma
#    Corrente : /bases/sss.000/proc
#     Chamada : ./DOICreatePadrao.sh
# Observacoes : Efetua a chamada com parametros fixos relativos ao 
#                 processamento SciELO anterior
# ------------------------------------------------------------------------- #
#   Data    Responsavel       Comentarios
# 20070515  MBottura/FJLopes  Edicao original
#

TPR="start"
. log

# Processa com a lista do ultimo processamento
doi/create/main.bat lista/scilista.lst outs/DOI.out

# Anda a fila de lista para processamento
mv lista/nxt.scilista.lst lista/scilista.lst

TPR="end"
. log
