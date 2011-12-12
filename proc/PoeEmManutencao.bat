export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem          batch/ManutencaoOn.bat
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Coloca o sitio do SciELO.SP em manutencao
echo
echo Este arquivo executara: 
echo
echo  batch/ManutencaoOn.bat
echo
echo utilizando como parametros /mnt/scielo-online/scielosp/www/bases
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

rem Inicializa variaveis
export INFORMALOG=log/AtualizaScieloLattesMedline.log
export CISIS_DIR=cisis

echo Parando SciELO.SP
echo
call batch/ManutencaoOn.bat /mnt/scielo-online/scielosp/www/bases
echo
echo SciELO.SP em manutencao agora.

