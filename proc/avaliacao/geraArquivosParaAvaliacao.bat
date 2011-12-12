export PATH=$PATH:.
rem @echo off

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem export SHELL=C:/COMMAND.COM /P /E:1024

rem geraArquivosParaAvaliacao
rem Parametro 1: number of the meeting
rem Parametro 2: date of the meeting
rem Parametro 3: diretorio

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 number of the meeting
call batch/VerifPresencaParametro.bat $0 @$2 date of the meeting
call batch/VerifPresencaParametro.bat $0 @$3 directory

./avaliacao/prepareEnv.bat ../bases/title/title ../avaliacao/input/newcode ../bases/issue/issue ../bases/artigo/artigo $1 $2 ../avaliacao/input/title_aux ../avaliacao/input/titlelist_br.txt $3
