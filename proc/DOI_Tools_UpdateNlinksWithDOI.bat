export PATH=$PATH:.
export CISIS_DIR=cisis
INFORMALOG=log/UpdateNlinksWithDOI.log

rem Este arquivo é uma chamada para o 
rem rem UpdateNlinksWithDOI.bat com parâmetros STANDARD

echo === ATENCAO ===
echo 
echo Este arquivo executara o seguinte comando
echo UpdateNlinksWithDOI.bat 
echo 
echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

echo UpdateNlinksWithDOI

echo Atualiza a base nlinks
cisis/mx ../bases/medline/nlinks "proc=@prc/doi_add2nlinks.prc" copy=../bases/medline/nlinks now -all 
cisis/mx ../bases/doi/doi "proc=@prc/doi_create_nlinks.prc" append=../bases/medline/nlinks now -all
call batch/GeraInvertido.bat ../bases/medline/nlinks ../bases/medline/nlinks.fst ../bases/medline/nlinks
