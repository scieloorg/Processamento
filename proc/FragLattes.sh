# ------------------------------------------------------------------------- #
# Efetua as tarefas de recepcao e preparo de Lattes
# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 02] Toma dados Lattes do CNPq
# Acessa area de FTP CPNq
#  - le arquivo "ArquivoLinkLattesScielo.zip" ou "ArquivoLinkLattesScielo.txt.gz"
#  - coloca em ../bases/lattes
echo "==> Inicia sessao FTP"
echo "Cria arquivo de controle de sessao FTP - CNPq"
cat >lattes_.ftp<<!
open ftp1.cnpq.br
user usrbireme b!r@n#
cd scielo
bin
get ArquivoLinkLattesScieloXX.txt.gz
bye
!
ftp -i -v -n < lattes_.ftp
rm lattes_.ftp
echo "==>Encerra sessao FTP"
echo "Coloca arquivo recebido no diretorio do Lattes"
mv ArquivoLinkLattesScieloXX.txt.gz ../bases/lattes

# [flx_FechaSciELO.txt : 03] Pre-processa dados recebidos do CNPq
# - Efetua back-up do ultimo arquivo recebido para processamento
# - Descompacta arquivo recebido
# - Filtra somente as linhas cmo os campos 1 ate 4 presentes
# - Avalia o numero de linhas e assume o maior dos arquivos

cd ../bases/lattes
 echo "Guarda ultima versao utilizada do retorno do CNPq"
 mv lattes.seq lattes.old
 echo "Descompacta o pacote recebido do CNPq"
 rm -f ArquivoLinkLattesScieloXX.txt
 gzip -d ArquivoLinkLattesScieloXX.txt.gz
 echo "Toma so as linhas do arquivo com todos os campos presentes"
 mx seq=ArquivoLinkLattesScieloXX.txt lw=99999 "pft=if p(v1) and p(v2) and p(v3) and p(v4) then v1,'|',v2,'|',v3,'|',v4/ fi" now > lattes.seq
 echo "Seleciona qual arquivo deve utilizar para os links Lattes"
 export OLDLN=`wc -l lattes.old | cut -c-8 | tr -d " "`
 export OLDLN=`wc -l lattes.old | cut -d " " -f "1"`
 export NEWLN=`wc -l lattes.seq | cut -c-8 | tr -d " "`
 export NEWLN=`wc -l lattes.seq | cut -d " " -f "1"`
 if [ $NEWLN -lt $OLDLN ]
 then
   echo "Volta arquivo anterior para operacao"
   mv lattes.old lattes.seq
 fi
 # Plano de contingencia entrando em acao pois LATTES.SEQ estava zerado
 if [ ! -s lattes.seq ]
 then
   cp lattes.contingencia lattes.seq
 fi
cd -

