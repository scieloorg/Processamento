export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem AtualizaScieloOnLine
rem Parametro 1: diretorio bases do ambiente de testes - area de testes
rem Parametro 2: diretorio bases do ambiente onLine - area online - producao liberada
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/AtualizaScieloOnLine.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 diretorio bases do ambiente de testes
call batch/VerifPresencaParametro.bat $0 @$2 diretorio bases do ambiente onLine
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

# Atualizacao antiga
# Alterado por Asael 03-Apr-2003
# call batch/CopiaDiretorio.bat $1/title $2
# call batch/CopiaDiretorio.bat $1/artigo $2
# call batch/CopiaDiretorio.bat $1/newissue $2
# call batch/CopiaDiretorio.bat $1/issue $2
# call batch/CopiaDiretorio.bat $1/iah $2

# Atualizacao nova - scielo3 para scielo
# dividido entre atualizacao de diretorios
call batch/CopiaDiretorio.bat $1/bib/jlist/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/1997/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/1998/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/1999/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/2000/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/2001/ $2/bib
call batch/CopiaDiretorio.bat $1/bib/2002/ $2/bib
# call batch/CopiaDiretorio.bat $1/bib/2003/ $2/bib
call batch/CopiaDiretorio.bat $1/iah/ $2
call batch/CopiaDiretorio.bat $1/issue/ $2
call batch/CopiaDiretorio.bat $1/newissue/ $2
call batch/CopiaDiretorio.bat $1/stop/ $2
call batch/CopiaDiretorio.bat $1/title/ $2
call batch/CriaDiretorio.bat $2/doi

# e atualizacao de arquivos pontuais
# para evitar copia de lixo
$CISIS_DIR/mx "seq=lista/lista-arquivos-bases.txt" lw=9000 "pft='call batch/CopiaArquivo.bat $1/',v1,x1,'$2/',v1/" now >temp/AtualizaSciELOOnlineNovo.bat
chmod 0777 temp/AtualizaSciELOOnlineNovo.bat
call temp/AtualizaSciELOOnlineNovo.bat


call batch/InformaLog.bat $0 dh ===Fim===
