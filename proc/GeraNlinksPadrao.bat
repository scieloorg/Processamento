export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          GeraNlinks.bat ../bases log/GeraNlinksPadrao.bat adiciona
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo   GeraNlinks.bat .. log/GeraNlinksPadrao.bat adiciona
echo
echo utilizando como parametros ../bases /home/scielo/www/bases log/AtualizaPadrao.log adiciona
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

call GeraNlinks.bat ../bases log/GeraNlinksPadrao.log adiciona
