rem export PATH=$PATH:.
rem GeraInvIAHProc
rem Parametro 1: path producao SciELO
rem Parametro 2: base que contem a lista de bases para inverter

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 base_com_lista_de_bases_para_inverter_para_o_IAH

echo "== [INI] Chamada de $0 as: `date` ==">> /bases/scl.000/tinvIAHProc.txt

call batch/InformaLog.bat $0 x Gera invertidos do IAH
call batch/CriaDiretorio.bat ../bases-work/iah
# call batch/CriaDiretorio.bat ../bases-work/iah/library
# call batch/GeraInvertidoProc.bat ../bases-work/artigo/artigo fst/search.fst ../bases-work/iah/library/search
# call batch/GeraInvertidoProc.bat ../bases-work/artigo/artigo fst/searchp.fst ../bases-work/iah/library/searchp

rem #
rem # Usa as bases de cada revista em base-work para fazer seus indices especificos
rem #

echo rem GeraInvIAH >temp/GeraInvIAH.bat
rem 1
$CISIS_DIR/mx $2 lw=9000 "pft='call batch/CriaDiretorio.bat ../bases-work/iah/',v1,/" now -all >>temp/GeraInvIAH.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $2 - criacao batch temp/GeraInvIAH.bat passo 1
rem 2
$CISIS_DIR/mx $2 lw=9000 "pft='call batch/GeraInvertido.bat ../bases-work/',v1,'/',v1,x1,'fst/search.fst',x1,'../bases-work/iah/',v1,'/search',/" now -all   >>temp/GeraInvIAH.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $2 - criacao batch temp/GeraInvIAH.bat passo 2
rem 3
$CISIS_DIR/mx $2 lw=9000 "pft='call batch/GeraInvertido.bat ../bases-work/',v1,'/',v1,x1,'fst/searchp.fst',x1,'../bases-work/iah/',v1,'/searchp',/" now -all >>temp/GeraInvIAH.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $2 - criacao batch temp/GeraInvIAH.bat passo 3
chmod 700 temp/GeraInvIAH.bat
call temp/GeraInvIAH.bat

echo "== [FIM] Chamada de $0 as: `date` ==">> /bases/scl.000/tinvIAHProc.txt

