#!/bin/bash
# ------------------------------------------------------------------------- #
# Efetua o descarte de temporarios em bases-work e reconstroi bases e indices
# ------------------------------------------------------------------------- #
#  Entrada: nenhuma
# Corrente: [RAIZ_SciELO]/proc
# ------------------------------------------------------------------------- #
#   DATA    Responsavel        Comentarios
# 20080515  FBCSantos/FJLopes  Edicao original

# Gera lista de titulos correntes para efetuar limpeza
./toolListaAcronimosTitle.sh c | sort -u > desintoxica.lst

# Limpa cada item de lista
for i in `cat desintoxica.lst`
do
	./toolDesintoxicaRevistaBasesWork.sh $i
done

# Limpa area de trabalho
rm desintoxica.lst
