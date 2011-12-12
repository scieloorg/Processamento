export PATH=$PATH:.
export CISIS_DIR=cisis
rem Este arquivo é uma chamada para o 
rem batch/GenerateDOI_Query.bat

rem echo === ATENCAO ===
rem echo 
rem echo Este arquivo executara o seguinte comando
rem echo batch/GenerateDOI_Query.bat base_artigo
rem echo 
rem echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem batch/GenerateDOI_Query
rem Parametro 1: base artigo

rem Inicializa variaveis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 base artigo

cisis/mx ../bases-work/artigo/artigo gizmo=gizmo/win2ent btell=0 lw=99999 "MDL=$1" "proc=@prc/Article.prc" "pft=@pft/doi_query.pft" now -all

