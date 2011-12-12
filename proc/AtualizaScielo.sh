export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          AtualizaLattesOnLine.bat
rem          AtualizaMedlineOnLine.bat
rem          AtualizaScieloOnLine.bat
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo ATUALIZACAO DO SITE WWW.SCIELO.BR
echo
echo Este arquivo executara: 
echo
echo  AtualizaLattesOnLine.bat
echo  AtualizaMedlineOnLine.bat
echo  AtualizaScieloOnLine.bat
echo
echo utilizando como parametros ../bases /home/scielosp/www/bases log/AtualizaPadrao.log adiciona
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

# read pause

rem Inicializa variaveis
export INFORMALOG=log/AtualizaScieloLattesMedline.log
export CISIS_DIR=cisis

echo SC3
echo atualizando scielo3 - antigo
date
call batch/ManutencaoOn.bat /home/scielosp/www/bases
call AtualizaLattesOnLine.bat ../bases /home/scielosp/www/bases log/AtualizaPadrao.log adiciona
call AtualizaMedlineOnLine.bat ../bases /home/scielosp/www/bases log/AtualizaPadrao.log adiciona
call AtualizaScieloOnLine2.bat ../bases /home/scielosp/www/bases log/AtualizaPadrao.log adiciona
call batch/ManutencaoOff.bat /home/scielosp/www/bases
echo finalizando atualizacao scielo3 - antigo
date
