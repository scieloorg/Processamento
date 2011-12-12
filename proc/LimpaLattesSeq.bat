export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem GeraBasesExternas
rem Parametro 1: diretorio isos/seqs bases externas
rem Parametro 2: arquivo de log
rem Parametro 3: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/GeraBasesExternas.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 diretorio isos/seqs bases externas
call batch/VerifPresencaParametro.bat $0 @$2 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$3 opcao do LOG: cria/adiciona

if [ "$3" == "cria" ]
then
   call batch/DeletaArquivo.bat $2
fi
export INFORMALOG=$2

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/Seq2Master.bat $1/lattes/lattes.seq pipe $1/lattes/lattes
echo >LimpaSeqLattes.prc
echo >>LimpaSeqLattes.prc
call batch/Master2Seq.bat $1/lattes/lattes.seq pipe $1/lattes/lattes LimpaSeqLattes.prc

call batch/InformaLog.bat $0 dh ===Fim===
