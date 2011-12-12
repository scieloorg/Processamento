export PATH=$PATH:.

rem Este arquivo eh uma chamada para o
rem Envia2Medline.bat .. transf/Envia2MedlinePadrao.txt log/envia2medline.log cria
rem com parametros padronizados.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2Medline.bat .. transf/Envia2MedlinePadrao.txt log/envia2medlineFTP.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

rem read pause

# Chamada de parametros para a Instancia
. SciELO.inc

call Envia2Medline.bat .. transf/Envia2MedlinePadrao.txt log/envia2medlineFTP.log cria

cat >mensagem.txt <<!
Envio concluído.
!
mail -s "[SciELO-$SIGLA2] Fim Envia2MedlinePadrao.bat" francisco.lopes@scielo.org -c fabio.brito@bireme.org <./mensagem.txt
rm mensagem.txt

