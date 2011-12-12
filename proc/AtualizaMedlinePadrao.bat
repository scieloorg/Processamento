export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          AtualizaMedlineOnLine.bat
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo ATUALIZACAO DE NLINKS NO SITE WWW.SCIELO.BR
echo
echo Este arquivo executara: 
echo
echo  AtualizaMedlineOnLine.bat
echo
echo utilizando como parametros ../bases /home/scielosp/www/bases log/AtualizaNlinksPadrao.log adiciona
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

call AtualizaMedlineOnLine.bat ../bases /home/scielosp/www/bases log/AtualizaNlinksPadrao.log adiciona
