export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem Envia2SciELOSPOnline.bat /usr/scielosp/scielo-prod transf/Envia2SciELOSPOnline.txt log/envia2scielosponline.log cria
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2SciELOSPOnline.bat /usr/scielosp/scielo-prod transf/Envia2SciELOSPOnline.txt log/envia2scielosponline.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

call Envia2SciELOSPOnline.bat /usr/scielosp/scielo-prod transf/Envia2SciELOSPOnline.txt log/envia2scielosponline.log cria
