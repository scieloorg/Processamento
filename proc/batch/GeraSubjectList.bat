rem GeraInvertido
rem Nao tem parametros

call batch/VerifExisteBase.bat ../bases-work/title/title

call batch/InformaLog.bat $0 x Gera indice de areas de assunto: serareaII

$CISIS_DIR/mx ../serial/code/newcode btell=0 "EN-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de areas de estudo em ingles
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/ENstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 geracao de base temporaria de areas de estudo em ingles
$CISIS_DIR/mx temp/ENstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/ENstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de base temporaria de areas de estudo em ingles

$CISIS_DIR/mx ../serial/code/newcode btell=0 "ES-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de areas de estudo em espanhol
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/ESstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 geracao de base temporaria de areas de estudo em espanhol
$CISIS_DIR/mx temp/ESstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/ESstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de base temporaria de areas de estudo em espanhol

$CISIS_DIR/mx ../serial/code/newcode btell=0 "PT-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 extracao de areas de estudo em portugues
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/PTstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 geracao de base temporaria de areas de estudo em portugues
$CISIS_DIR/mx temp/PTstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/PTstudyareas
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de base temporaria de areas de estudo em portugues

rem Gera invertido por idioma
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|EN|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaEN
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de areas em ingles
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|ES|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaES
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de areas em espanhol
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|PT|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaPT
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 indexacao de areas em portugues

call batch/DeletaArquivo.bat temp/xstudyareas

call batch/DeletaArquivo.bat temp/ENstudyareas.cnt
call batch/DeletaArquivo.bat temp/ENstudyareas.iyp
call batch/DeletaArquivo.bat temp/ENstudyareas.ly1
call batch/DeletaArquivo.bat temp/ENstudyareas.ly2
call batch/DeletaArquivo.bat temp/ENstudyareas.mst
call batch/DeletaArquivo.bat temp/ENstudyareas.n01
call batch/DeletaArquivo.bat temp/ENstudyareas.n02
call batch/DeletaArquivo.bat temp/ENstudyareas.xrf

call batch/DeletaArquivo.bat temp/ESstudyareas.cnt
call batch/DeletaArquivo.bat temp/ESstudyareas.iyp
call batch/DeletaArquivo.bat temp/ESstudyareas.ly1
call batch/DeletaArquivo.bat temp/ESstudyareas.ly2
call batch/DeletaArquivo.bat temp/ESstudyareas.mst
call batch/DeletaArquivo.bat temp/ESstudyareas.n01
call batch/DeletaArquivo.bat temp/ESstudyareas.n02
call batch/DeletaArquivo.bat temp/ESstudyareas.xrf

call batch/DeletaArquivo.bat temp/PTstudyareas.cnt
call batch/DeletaArquivo.bat temp/PTstudyareas.iyp
call batch/DeletaArquivo.bat temp/PTstudyareas.ly1
call batch/DeletaArquivo.bat temp/PTstudyareas.ly2
call batch/DeletaArquivo.bat temp/PTstudyareas.mst
call batch/DeletaArquivo.bat temp/PTstudyareas.n01
call batch/DeletaArquivo.bat temp/PTstudyareas.n02
call batch/DeletaArquivo.bat temp/PTstudyareas.xrf
