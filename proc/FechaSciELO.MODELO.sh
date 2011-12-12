
 ############################################################################
 #                                                                          #
 # ATENCAO: Sete passos para configurar uma nova instancia de processamento #
 #                                                                          #
 #   1 renomear Frag*.MODELO.* para Frag*.SIGLA2.*                          #
 #   2 editar Frag* (Comentario lembrete de servidor e path dos dados)      #
 #   3 editar formato de Google Scholar  linhas 66, 67, e 68                #
 #       (scielo_gsc/formats/googleSchoolar_XMLPubMed.pft)                  #
 #   4 editar scielo_gsc/shs/googleSchoolar_config.sh                       #
 #   5 editar transf/Envia2MedlinePadrao.txt                                #
 #   6 renomear Processa e Fecha                                            #
 #   7 editar Processa e Fecha                                              #
 #                                                                          #
 #                                                                          #
 ############################################################################

#!/bin/bash
# ------------------------------------------------------------------------- #
# FechaSciELO.MODELO.sh - Finaliza processamento do SciELO
# ------------------------------------------------------------------------- #
#      Entrada : Data e hora de recebimento do e-mail do SciELO
#        Saida : Diversas
#      Chamada : nohup ./FechaSciELO.MODELO.sh >& outs/fimPX.YYYYMMDD.out &
#     Corrente : /bases/sss.xxx/proc
#  Observacoes : No arquivo lista/responsavel estah o e-mail do operador
#                  responsavel pelo processamento
#                Observacoes relevantes em geral como por exemplo:
#                  a cada sequencia /[^/]* descemos um nivel na arvore de dir
#        Notas : 
# Dependencias : Diversas
# ------------------------------------------------------------------------- #
# Caracteristicas de processamento
#

SERVPRC=`echo $HOSTNAME | cut -d "." -f "1"`

# Chamada de parametros para a Instancia
. SciELO.inc

#LATTES=TRUE            # Processa Lattes
#NLINKA=TRUE            # Processa nLinks ### ATENCAO ELIMINAR iLinks-${SIGLA3} onde necessario ###
#BIBLIOM=TRUE           # Processa Bibliometria
#SCIELOORG=TRUE         # Integra SciELO.ORG
#COLLEXIS=TRUE          # Processa Collexis
#TEXTLANG=TRUE          # Processa idioma de texto
#AREAGEO=TRUE           # Processa Areas Geograficas mma/genAG.sh
#GOOGLESCL=TRUE         # Processa Google Scholar
#XREFART=TRUE           # Processa DOI de ARTIGOS
#XREFREF=TRUE           # Processa DOI de REFERENCIAS
#SCILOG=TRUE            # Prepara dados para SciELO-LOG

# ------------------------------------------------------------------------- #
#   DATA    RESPONSAVEL       COMENTARIOS
# 20071128  MBottura/FJLopes  Edicao original
# 20090707  FBrito/FJlopes    Inclusao de condicional para remover *.ftp
#                             Normalizacao dos parametros utilizados - SciELO.inc
# 20091001  FJlopes/Fbrito    Inclusao de condicional para criacao do diretorio temp/transf2lattes
# 20091008  FBrito            Geracao de estatistica em XML para serverofi
#                             Inclusao do flag BIBLIOM
# 20100505  FLBrito/FJLopes   Desligamento de COLLEXIS
# ------------------------------------------------------------------------- #

TPR="start"
. log

# Anota hora de inicio de operacao de liberacao
HINIC=`date '+%s'`
HRINI=`date '+%Y.%m.%d %H:%M:%S'`
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] $0 $1 $2 $3 $4 $5"

# ------------------------------------------------------------------------- #
# Ajustes de ambiente

# Determina caminho absoluto para escrever o arquivo de parametros do CISIS
# (/bases/sss.nnn/...)
# ($LGRAIZ/$LGPRD/...)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de producao (segundo nivel da arvore do diretorio corrente)
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
LGPRD1=`echo $LGPRD|cut -d "." -f "1"`

unset LGDTC LGRAIZ

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 01] Envia e-mail de OS::

if [ "$#" -eq "0" ]
then
	DTEMAIL=`date '+%d/%m/%Y'`
else
	DTEMAIL=$1
fi

echo "A equipe OFI,"                                         > mensagem.txt
echo ""                                                     >> mensagem.txt
echo ""                                                     >> mensagem.txt
echo "O processamento de SciELO foi executado com sucesso." >> mensagem.txt
echo "Favor transferir para producao."                      >> mensagem.txt
echo ""                                                     >> mensagem.txt
echo ""                                                     >> mensagem.txt
echo "Atenciosamente"                                       >> mensagem.txt
echo "[SciELO.${SIGLA2}]  $DTEMAIL - Liberar homologacao"    > assunto
# mail -s "OS:: `cat assunto`" xxx@xxxxxx.xxx                < mensagem.txt
rm mensagem.txt

if [ $LATTES ]
then
# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 02] Toma dados Lattes do CNPq
	# Acessa area de FTP CPNq para ler o arquivo "ArquivoLinkLattesScielo.zip" ou "ArquivoLinkLattesScielo.txt.gz"
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Toma dados de Lattes no CNPq"
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] ftp ftp1.cnpq.br"
	echo "Cria arquivo de controle de sessao FTP - CNPq"

        echo "open ftp1.cnpq.br"                            > lattes.ftp
        echo "user usrbireme b!r@n#"                       >> lattes.ftp
        echo "cd scielo"                                   >> lattes.ftp
        echo "bin"                                         >> lattes.ftp
        echo "get ArquivoLinkLattesScielo${SIGLA2}.txt.gz" >> lattes.ftp
        echo "bye"                                         >> lattes.ftp

	ftp -i -v -n                                        < lattes.ftp

	rm lattes.ftp

	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] ftp ftp1.cnpq.br"
	echo "Coloca arquivo recebido no diretorio do Lattes"
	mv ArquivoLinkLattesScielo${SIGLA2}.txt.gz ../bases/lattes
	
	# [flx_FechaSciELO.txt : 03] Pre-processa dados recebidos do CNPq
	# - Efetua back-up do ultimo arquivo recebido para processamento
	# - Descompacta arquivo recebido
	# - Filtra somente as linhas cmo os campos 1 ate 4 presentes
	# - Avalia o numero de linhas e assume o maior dos arquivos
	cd ../bases/lattes
	 echo "Guarda ultima versao utilizada do retorno do CNPq"
	 mv lattes.seq lattes.old
	 echo "Descompacta o pacote recebido do CNPq"
	 rm -f ArquivoLinkLattesScielo${SIGLA2}.txt
	 gzip -d ArquivoLinkLattesScielo${SIGLA2}.txt.gz
	 echo "Toma so as linhas do arquivo com todos os campos presentes"
	 mx seq=ArquivoLinkLattesScielo${SIGLA2}.txt lw=99999 "pft=if p(v1) and p(v2) and p(v3) and p(v4) then v1,'|',v2,'|',v3,'|',v4/ fi" now > lattes.seq
	 echo "Seleciona qual arquivo deve utilizar para os links Lattes"
	 # Codigo para Had Hat 7.x: cut -c-8 | tr -d " "
	 # Codigo para Fedora Core: cut -d " " -f "1"
	 export OLDLN=`wc -l lattes.old | cut -d " " -f "1"`
	 export NEWLN=`wc -l lattes.seq | cut -d " " -f "1"`
	 if [ $NEWLN -lt $OLDLN ]
	 then
	   echo "Volta arquivo anterior para operacao"
	   mv lattes.old lattes.seq
	 fi
	 # Plano de contingencia entrando em acao quando LATTES.SEQ esta zerado
	 if [ ! -s lattes.seq ]
	 then
	   echo "Retoma copia de emergencia"
	   cp lattes.contingencia lattes.seq
	 fi
	cd -
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Toma dados de Lattes no CNPq"
else
        mkdir -p temp/transf2lattes
        touch SciELO.txt
fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 04] Toma dados de nLinks em ServerX
if [ $NLINKA ]
then
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Toma dados de nLinks de ServerX"
	if [ $IN_BIR ]
	then
	        scp ${SLINK}:${PATH_LINKS}/${SIGLA3}.lnk/last_nlinks/nlinks.iso ../bases/medline
	else
	        echo "open ${SLINK}"                               > ftp_${SIGLA3}.ftp
	        echo "${FTPLOGIN}"                                >> ftp_${SIGLA3}.ftp
	        echo "bin"                                        >> ftp_${SIGLA3}.ftp
	        echo "cd ${PATH_LINKS}/${SIGLA3}.lnk/last_nlinks" >> ftp_${SIGLA3}.ftp
	        echo "lcd ../bases/medline"                       >> ftp_${SIGLA3}.ftp
	        echo "get nlinks.iso"                             >> ftp_${SIGLA3}.ftp
	        echo "bye"                                        >> ftp_${SIGLA3}.ftp
	        cat   ftp_${SIGLA3}.ftp
	        ftp -i -v -n                                       < fpt_${SIGLA3}.ftp
	        rm -f ftp_${SIGLA3}.ftp
	fi
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Toma dados de nLinks de ServerX"
fi
	
# [flx_FechaSciELO.txt : 05] Gera links externos de SciELO
if [ $LATTES -o $NLINKA ]
then
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Gera bases de links com Lattes e iAH"
	./GeraBasesExternasPadrao.bat
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Gera bases de links com Lattes e iAH"

        # [flx_FechaSciELO.txt : 05a] Atualiza bases de links externos na homologacao
        echo "-lattes"
        scp ../bases/lattes/lattes.cnt ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
        scp ../bases/lattes/lattes.iyp ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
        scp ../bases/lattes/lattes.ly? ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
        scp ../bases/lattes/lattes.n0? ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
        scp ../bases/lattes/lattes.mst ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/
        scp ../bases/lattes/lattes.xrf ${HOMOL}:$PATH_BASES_HOMOLOG/lattes/

        echo "-medline"
        scp ../bases/medline/nlinks.cnt ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
        scp ../bases/medline/nlinks.iyp ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
        scp ../bases/medline/nlinks.ly? ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
        scp ../bases/medline/nlinks.n0? ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
        scp ../bases/medline/nlinks.mst ${HOMOL}:$PATH_BASES_HOMOLOG/medline/
        scp ../bases/medline/nlinks.xrf ${HOMOL}:$PATH_BASES_HOMOLOG/medline/

fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 06] Prepara dados para SciELO-LOG
# ATENCAO: ISOs ja gerados na execucao de Envia2MedlinePadrao durante o Processa_SciELO.sh
#  [root@pr11pet accesslog]# pwd
#  /bases/accesslog
#  [root@pr11pet accesslog]# ll
#  drwxrwxr-x 2 galvao galvao    4096 Feb 19  2008 iahlog
#  drwxrwx--- 3 apache apache   57344 Apr  2 00:02 log_jpneumo
#  drwxrwxr-x 2 apache apache    4096 Apr  1  2008 log_jvatitd
#  drwxrwx--- 2 apache apache   20480 Jun 16  2008 log_rbcard
#  drwxrwxr-x 2 apache apache   32768 Apr  2 00:00 log_rbccv
#  drwxrwxr-x 2 apache apache    4096 Oct 11  2007 log_rbfis
#  drwxrwx--- 2 apache apache   12288 Dec  8 17:33 log_rborl
#  drwxrwx--- 8 apache scieloup  4096 Apr  2 00:00 log_scielo
#  drwxrwxr-x 6 apache apache    4096 Nov 30  2007 log_scielodiv
#  drwxrwxr-x 6 apache apache    4096 Nov 30  2007 log_scieloem
#  drwxrws--- 6 apache cdrom     4096 Apr  2 01:30 log_scielosp
#  drwxrwxr-x 6 apache apache   20480 Apr  2 00:01 log_scieloss
#  drwxrwxr-x 6 apache apache    4096 Nov 30  2007 log_scielowin

if [ $SCILOG ]
then
	echo "Inicia empacotamento de dados para SciELO-LOG"
	# Gera a estrutura de "deposito" dos arquivos e movimenta individuos para posterior transferencia a scielo-log em Tambore
	mkdir -p temp/bases/accesslog/log_scielo.$SIGLA3
	# Manda copia dos dados para a estrutura de deposito
	cp temp/transf2medline/issue.iso  temp/bases/accesslog/log_scielo.$SIGLA3
	cp temp/transf2medline/titsci.iso temp/bases/accesslog/log_scielo.$SIGLA3
	cp temp/transf2medline/artigo.iso temp/bases/accesslog/log_scielo.$SIGLA3
	echo "Finda empacotamento de dados para SciELO-LOG"
        echo "Envia imagem de dados para destino centralizado"
        scp -r temp/bases/accesslog/* scielpx1:/bases/accesslog
        echo "Envio concluido"
fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 07] Envia e-mail de atualizacao ao ITI
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Envia e-mail pedindo atualizacao ao ITI"
# Emite e-mail ao ITI solicitando atualizacao

if [ $BIBLIOM ]
then
export ATU_BIBLIO="Os dados de bibliometria presentes no servidor de homologacao devem ser atualizados."

	# Gera estatistica XML para SERVEROFI
	./estBIBLIOxml.sh

fi

cat >mensagem.txt <<!
A equipe ITI,

Atualizacao do sitio oficial SciELO.${SIGLA2} de `date +%d/%m/%Y` esta apta a ser efetuada.
Por favor, efetuem o processo informando sua conclusao a scielo-lista@scielo.org

Diretorios sob ${HOMOL}:${PATH_BASES_HOMOLOG} (e subdiretorios) participantes da atualizacao:
  - artigo;
  - iah;
  - img;
  - issue;
  - lattes;
  - medline;
  - newissue;
  - pdf;
  - title; e
  - translation

  - areasgeo;
  - cited;
  - doi;
  - related;

Diretorios sob ${HOMOL}:${PATH_BASES_HOMOLOG} que NAO participam da atualizacao:
  ftp; iso; logdia; stop; tab; temp (parcial); user

Os diretorios sob ${HOMOL}:/home/statbiblio-${SIGLA2}/www (e subdiretorios) participantes da atualizacao:
  - cgi-bin;
  - htdocs; e
  - scibiblio

Os dados de Google Scholar, relativos ao SciELO.${SIGLA2}, estao disponiveis para transferencia em:
  ${SERVPRC}:/bases/${SIGLA3}.000/proc/output/googleSchoolar

Os dados para SciELO-LOG (Tambore) estao disponiveis para transferencia sob:
  ${SERVPRC}:/bases/accesslog/log_scielo.${SIGLA3}/*
e/ou
  ${SERVPRC}:/bases/${SIGLA3}.000/proc/temp/bases/accesslog/log_scielo.${SIGLA3}

${ATU_BIBLIO}

 Ednilson Gessef / Francisco J. Lopes
 Fone: 11 3369-445 scielo-lista@scielo.org < mensagem.txt
rm mensagem.txt
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Envia e-mail pedindo atualizacao ao ITI"

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 08] Envia dados Lattes para o CNPq
if [ $LATTES ]
then
	# Efetua tarefas de envio de dados para CNPq
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Geracao de dados para CNPq"
	./Envia2LattesPadrao.bat
	echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Geracao de dados para CNPq"
	
	# [flx_FechaSciELO.txt : 09] Envia e-mail de aviso para o CNPq
	cat >mensagem.txt <<!
Prezados Senhores,

Encontra-se disponivel para processamento em vosso servidor de FTP (ftp1.cnpq.br) no diretorio "/aplic1/instituicoes/bireme/scielo" o arquivo SciELO${SIGLA2}.txt.gz, atualizado em `date '+%d/%m/%Y'`.

Sem mais para o momento, atenciosamente

 Fabio Batalha / Francisco J. Lopes
 BIREME Fone: (11)3369-4015
!
	mailx -s "[SciELO.${SIGLA2}] Arquivo SciELO-Lattes disponivel em $(date '+%d/%m/%Y')" caraujo@cnpq.br -c scielo-lista@scielo.org < mensagem.txt
	rm mensagem.txt
fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 10] Envia liberacao para pre-processamento de COLLEXIs para ServerX
if [ $COLLEXIS ]
then
	LETRAS=`echo $SIGLA2 | tr [[:upper:]] [[:lower:]]`
	# - Emite flags de liberacao de processamento
	echo "Emissao de flags de liberacao de processamento - inicio"
	echo "`date '+%Y%m%d %H%M%S'`"       > collexis.scielo${LETRAS}
	echo "open ${SLINK}"                 > p_collex.ftp
	echo "${FTPLOGIN}"                  >> p_collex.ftp
	echo "asc"                          >> p_collex.ftp
	echo "cd /bases/sci.000/sci.sci"    >> p_collex.ftp
	echo "put collexis.scielo${LETRAS}" >> p_collex.ftp
	echo "bye"                          >> p_collex.ftp
	ftp -i -v -n                         < p_collex.ftp
	rm p_collex.ftp
	echo "Emissao de flags de liberacao de processamento - fim"

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 11] Envia e-mail de pre-processamento de COLLEXIS em ServerX
	echo "Envia OS:: de Pre-Collexis - inicio"
	cat >mensagem.txt<<!
A equipe OFI,

Dados para geracao do XML da FI SciELO.${SIGLA2} - col_scielo${LETRAS}.xml
disponiveis desde `date '+%Y%m%d %H%M%S'` em ${SLINK}:
   ${PATH_LINKS}/art.${SIGLA3}/
   ${PATH_LINKS}/tit.${SIGLA3}/

Por favor, efetuar a geracao de XML Collexis para a FI

 Ednilson Gesseff / Francisco J. Lopes
 Fone: 3369-4085 ednilson.gessef@scielo.org
!
	#mail -s "OS:: [SciELO.${SIGLA2}] OFI processar collexis `date '+%d/%m/%Y'`" xxx@xxxxxx.xxx < mensagem.txt
	rm mensagem.txt
	echo "Envia OS:: de Pre-Collexis - fim"
fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 12] Envia e-mail de processamento de nLinks em ServerX
if [ $NLINKA ]
then

echo "Emissao de flags de liberacao de processamento - inicio"
echo "Pronto para processar iAHLinks em: `date '+%d-%m-%Y %H:%M:%S'`" > ilinks-${SIGLA3}.flg
echo "Pronto para processar  nLinks  em: `date '+%d-%m-%Y %H:%M:%S'`" > nlinks-${SIGLA3}.flg

if [ ${IN_BIR} ]
then
        echo "Efetuando o envio por SCP"
        scp ilinks-${SIGLA3}.flg ${SLINK}:${PATH_LINKS}; # Candidato a eliminacao
        scp nlinks-${SIGLA3}.flg ${SLINK}:${PATH_LINKS}
else
        echo "Efetuando o envio por FTP"
        echo "$SLINK"                > ftp_${SIGLA3}.ftp
        echo "$FTPLOGIN"            >> ftp_${SIGLA3}.ftp
        echo "cd $PATH_LINKS"       >> ftp_${SIGLA3}.ftp
        echo "put ilinks-${SIGLA3}" >> ftp_${SIGLA3}.ftp; # Candidato a eliminacao
        echo "put nlinks-${SIGLA3}" >> ftp_${SIGLA3}.ftp
        echo "bye"                  >> ftp_${SIGLA3}.ftp
        cat   ftp_${SIGLA3}.ftp
        ftp -i -v -n                 < ftp_${SIGLA3}.ftp
        rm -f ftp_${SIGLA3}.ftp
fi

	echo "Envia OS:: de processamento de nLinks - inicio"
	cat >mensagem.txt<<!
A equipe OFI,

Dados para geracao de nLinks de SciELO.${SIGLA2} disponiveis desde `date '+%Y%m%d %H%M%S'` em ${SLINK}:
   ${PATH_LINKS}/art.${SIGLA3}/
   ${PATH_LINKS}/b4c.${SIGLA3}/

Por favor, efetuar o processamento de nLinks

 Ednilson Gesseff / Francisco J. Lopes
  SciELO (11)3369-4085 / ednilson.gesseff@scielo.org
!
	mailx -s "OS:: [SciELO.${SIGLA2}] OFI processar nLinks $(date '+%d/%m/%Y')" ofi@listas.bireme.br < mensagem.txt
	rm mensagem.txt
	echo "Envia OS:: de processamento de nLinks - fim"

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 13] Envia e-mail de processamento de iAHLinks em ServerX
### Candidato a eliminacao
	echo "Envia OS:: de processamento de iAHLinks - inicio"
	cat >mensagem.txt<<!
A equipe OFI,

Dados para geracao de iAHlinks de SciELO.${SIGLA2} disponiveis desde `date '+%Y%m%d %H%M%S'` em ${SLINK}:
   ${PATH_LINKS}/art.${SIGLA3}/
   ${PATH_LINKS}/b4c.${SIGLA3}/

Por favor, efetuar o processamento de iAHLinks

 Ednilson Gesseff / Francisco J. Lopes
  SciELO (11)3369-4085 / ednilson.gesseff@scielo.org
!

        mailx -s "OS:: [SciELO.${SIGLA2}] OFI processar iAHLinks $(date '+%d/%m/%Y')" ofi@listas.bireme.br < mensagem.txt
	rm mensagem.txt
	echo "Envia OS:: de processamento de iAHLinks - fim"
fi
# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 14] Gera estatistica de processamento (deposita no sitio em ServerX)

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Estatisticas de processamento"
./StatSciELO.sh ${SIGLA2}
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Estatisticas de processamento"

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 15] Limpa area de trabalho

# Remove os dados deste processamento
	rm -rf ../serial/*

# Remove os diretorios de fasciculo sob os diretorios de colecoes
QTDE=$(ls -d ../bases-work/*/v[0-9]* | wc -l)
if [ $QTDE > 0 ]
then
	rm -rf ../bases-work/*/v[0-9]*
fi

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 16] Desintoxica as bases com colecao a colecao
# Talvez seja interessante que tambem inclua a desintoxicacao das bases dos titulos
##for i in `cat scilista.lst | cut -f "1" -d" "`
##do
##  ./toolDesintoxicaRevistasBasesWork.sh $i
##done

# ------------------------------------------------------------------------- #
# [flx_FechaSciELO.txt : 17] Emite e-mail de DOC:: para atualizacao ao OFI
echo "<doc>"                                                                       > mensagem.txt
echo " <request date=\"$DTEMAIL\">`cat assunto`</request>"                        >> mensagem.txt
echo " <where server=\"${HOMOL}\">${PATH_BASES_HOMOLOG}/*</where>"                >> mensagem.txt
echo " <what></what>"                                                             >> mensagem.txt
echo "</doc>"                                                                     >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo "---- mensagem original ----"                                                >> mensagem.txt
echo "ASSUNTO: `cat assunto`"                                                     >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo "A equipe OFI,"                                                              >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo "O SciELO.${SIGLA2} foi processado com sucesso."                             >> mensagem.txt
echo "Favor transferir para producao"                                             >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo ""                                                                           >> mensagem.txt
echo "Atenciosamente"                                                             >> mensagem.txt
echo "[SciELO.${SIGLA2}]  `date '+%d/%m/%y'` - Liberar homologacao para producao"  > assunto
# mail -s "DOC:: `cat assunto`" xxx@xxxxxx.xxx                                     < mensagem.txt
rm mensagem.txt
rm assunto

# ------------------------------------------------------------------------- #
unset CIPAR

# ------------------------------------------------------------------------- #
echo "Em `date '+%Y.%m.%d %H:%M:%S'` terminando $0 $1 $2 $3 $4 $5"

HFINI=`date '+%s'`
TPROC=`expr $HFINI - $HINIC`
echo "Tempo decorrido: $TPROC"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# Determina o nome do Shell chamado (sem o eventual path)
LGPRC=`expr "/$0" : '.*/\(.*\)'`

echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]">>$LGRAIZ/$LGPRD/outs/$LGPRC.tim
unset HINIC
unset HFINI
unset TPROC

TPR="end"
. log
