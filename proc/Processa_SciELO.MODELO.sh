
 ############################################################################
 #                                                                          #
 # ATENCAO: OITO passos para configurar uma nova instancia de processamento #
 #                                                                          #
 #   0 Consultar NOTAS em /bases/mod.elo                                    #
 #   1 renomear Frag*.MODELO.* para Frag*.SIGLA2.*                          #
 #   2 editar Frag* (Comentario lembrete de servidor e path dos dados)      #
 #   3 editar formato de Google Scholar  linhas 66, 67, e 68                #
 #       (scielo_gsc/formats/googleSchoolar_XMLPubMed.pft)                  #
 #   4 editar scielo_gsc/shs/googleSchoolar_config.sh                       #
 #   5 editar transf/Envia2MedlinePadrao.txt                                #
 #   6 renomear Processa e Fecha                                            #
 #   7 editar Processa e Fecha                                              #
 #                                                                          #
 ############################################################################

#!/bin/bash
# ------------------------------------------------------------------------- #
# Processa_SciELO.MODELO.sh - Coordena o processamento do SciELO
# ------------------------------------------------------------------------- #
#     entrada : Data e hora de recebimento do e-mail do SciELO
#               Base title de ../bases/title com a ultima versao de dados
#       saida : Arquivos processados entregues no servidor de homologacao
#     chamada : nohup ./Processa_SciELO.MODELO.sh >& outs/procPX.YYYYMMDD.out &
#    corrente : /bases/xxx.000/proc
# comentarios : Diversos sao os dados que devem estar previamente carregados
#                a exemplo das bases de dados revista a revista no diretorio
#                ../bases-work, alem de arquivos de formato em pft, de proc
#                em prc, de FST em fst e etc.
# observacoes : Processamento pode vir a ser passivel de ser chamado por CRONTAB
#               Arquivos flag empregados na sincronizacao entre maquinas:
#                StartSciELO.flg - Flag de inicio de processamento
#                   gohomolo.flg - Flag de preparo em receber dados de SciELOpx1
#
# Diretorios "fixos" de bases-work == nov-2007 ==
#	artigo	doi	iah	issue	lang	newissue	title
#
# Diretorios de bases-work dependentes da colecao ==00/0000 == :
#	xxx	hfhfklkn fjjfhdbfdjhbfd asfd
#
# ------------------------------------------------------------------------- #
# Caracteristicas de processamento
#

SERVPRC=$(echo $HOSTNAME | cut -d "." -f "1")

. SciELO.inc

# Flags de processamento
#LATTES=TRUE            # Processa Lattes
#NLINKA=TRUE            # Processa nLinks
#BIBLIOM=TRUE           # Processa Bibliometria
#SCIELOORG=TRUE         # Integra SciELO.ORG
#COLLEXIS=TRUE          # Processa Collexis
#TEXTLANG=TRUE          # Processa idioma de texto
#AREAGEO=TRUE           # Processa Areas Geograficas mma/genAG.sh
#GOOGLESCL=TRUE         # Processa Google Scholar
#SCIMAGO=TRUE           # Processa SCImago Journal & Country Rank
#XREFART=TRUE           # Processa DOI de ARTIGOS
#XREFREF=TRUE           # Processa DOI de REFERENCIAS
#SCILOG=TRUE            # Prepara dados para SciELO-LOG

# ------------------------------------------------------------------------- #
#   Data    Responsavel       Comentarios
# 20070509  MBottura/FJLopes  Edicao original
# 20070920  FJLopes           Revisao periodica
# 20080619  FBSantos/FJLopes  Inclusao de SCImago
# 20091007  FBrito/FJlopes    Duracao do processamento de Bibliometria
# 20100824  FJLopes           Revisao de padrao para operar em servidor unico novamente
# ------------------------------------------------------------------------- #

TPR="start"
. log

# Anota hora de inicio de processamento
HINIC=$(date '+%s')
HRINI=$(date '+%Y.%m.%d %H:%M:%S')
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:]  $0 $1 $2"

# ------------------------------------------------------------------------- #
# Ajustes de ambiente

# Determina caminho absoluto para escrever o arquivo de parametros do CISIS
# (/bases/sss.nnn/...)
# ($LGRAIZ/$LGPRD/...)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=$(pwd)
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/$(echo "$LGDTC" | cut -d/ -f2)
# Determina o nome do diretorio de producao (segundo nivel da arvore do diretorio corrente)
LGPRD=$(expr "$LGDTC" : '/[^/]*/\([^/]*\)')
LGPRD1=$(echo $LGPRD|cut -d "." -f "1")

unset LGDTC LGRAIZ

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 01] Envia e-mail de OS::

if [ "$#" -eq "0" ]; then
	DTEMAIL=$(date '+%d/%m/%Y')
else
	DTEMAIL=$1
fi

echo "A equipe OFI,"                                                          > mensagem.txt
echo ""                                                                      >> mensagem.txt
echo ""                                                                      >> mensagem.txt
echo "Os arquivos de SciELO ja estao disponiveis no servidor."               >> mensagem.txt
echo "Favor processar o SciELO.${SIGLA2}"                                    >> mensagem.txt
echo ""                                                                      >> mensagem.txt
echo ""                                                                      >> mensagem.txt
echo "Atenciosamente"                                                        >> mensagem.txt
echo "[SciELO.${SIGLA2}] $DTEMAIL - Processar SciELO.${SIGLA2}"               > assunto
# mail -s "OS:: $(cat assunto)" xxx@xxxxxx.xxx                                < mensagem.txt
rm mensagem.txt

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 02 ] Certifica forma de scilista.lst
echo "" >> ../serial/scilista.lst
echo "" >> ../serial/scilista.lst
sed 's/^$/artigo/' ../serial/scilista.lst > work
grep -v "^artigo" work > ../serial/scilista.lst
rm work
# ------------------------------------------------------------------------- #

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 03] Executa processamento padrao de SciELO
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento GeraPadrao"
./GeraPadrao.bat
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento GeraPadrao"

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 05] Geracao de indice de areas geograficas
if [ $AREAGEO ]; then
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de area geografica"
	cd mma
	./genAG.sh
	cd ..
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de area geografica"
fi
# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 6] Processamento de idiomas
if [ $TEXTLANG ]; then
	echo ""
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de idiomas"
	mount /bases/${LGPRD}/bases/pdf
	mount /bases/${LGPRD}/bases/translation
	
	procLangs/linux/doForList.bat ../serial/scilista.lst $LINDG4/mx ../bases-work/ ../bases-work/lang/lang log/procLangs.log
	
	umount /bases/${LGPRD}/bases/translation
	umount /bases/${LGPRD}/bases/pdf
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de idiomas"
	echo ""
fi
# ------------------------------------------------------------------------- #

# [flx_ProcessaSciELO.txt : 07] Executa procedimento de Xref opera artigos == Fabio
# ATENCAO: Mensagens capturadas em arquivo especifico de xref
if [ $XREFART ]; then
	echo ""
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processos de Xref"
	echo "Requisicao de registro de DOI para Crossref"
	cd scielo_crs/shs/
	./crossref_run_mod.sh >& ../../outs/crossref_run.out
	
	echo "Registro de erros:"
	$LIND/mx ../databases/crossref/crossref_DOIReport "ST=ERROR" -all count=1 now
	echo "---"
	cd -
	
# [flx_ProcessaSciELO.txt : 08] Executa procedimento de Query ao Xref para artigos == Roberta
# ATENCAO: Mensagens capturadas em arquivo especifico de xref

	echo "Gera scilista propria"
	touch criDoi.lst; rm criDoi.lst; touch criDoi.lst; doi/scilista/scilista4art.bat criDoi.lst
	
	echo "Query de DOI para Crossref"
	nohup doi/create/doi4art_mod.sh criDoi.lst log/QueryXref.log >& outs/qxref$(date '+%Y%m%d').out &
	
	echo -e "\n---\n\nLinhas em criDoi.lst: $(wc -l criDoi.lst)\n\n---\n" >>outs/qxref$(date '+%Y%m%d').out
	
	cp criDoi.lst outs/criDoi.$(date '+%Y%m%d').lst
	
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processos de Xref"
	echo ""
fi
# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 09] Prepara indices compactos

. FragCnvIDX.${SIGLA2}.sh

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 10] Envia primeira parte do processamento para ambiente de homologacao

.  FragEnvHM1.${SIGLA2}.sh
# . FragEnvSCL31.${SIGLA2}.sh

# ------------------------------------------------------------------------- #

# [flx_ProcessaSciELO.txt : 11] Envia e-mail liberando para teste de homologacao
cat >mensagem.txt <<!
A equipe SciELO,

Processamento SciELO.${SIGLA2} de $(date +%d/%m/%Y) concluido sem relato de erros.
Por favor, efetuem os testes de liberacao (http://scieloXXX.homolog.scielo.br/).

 Ednilson Gesseff/ Francisco Jose Lopes
 ednilson.gesseff@scielo.org / chico.scielo@gmail.com
 http://www.scielo.org | Fone: 33694085
!
mailx -s "Termino de processamento do SciELO.${SIGLA2}" scielo-lista@scielo.org < mensagem.txt
rm mensagem.txt
echo "[flx_ProcessaSciELO.txt : 11] Envia e-mail liberando para teste de homologacao"

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 12] Prepara processamento DOI de artigos
	# Passos 7 e 8 assumiram esta funcao

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 13] Processamento de afiliacao
cd ../bases/afiliacao
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de afiliacao"
./go.sh
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de afiliacao"
cd -

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 14] Processamento de bibliometria
if [ $BIBLIOM ]; then
	cd ../scibiblio/bases/estat/artigo

# ------------------------------------------------------------------------- #
# Gerando informacao de inicio de processamento de bibliometria
HINIBIBLI=$(date '+%s')
echo "$HINIBIBLI" > DURACAO.HINIBIBLI.txt
# ------------------------------------------------------------------------- #

	dos2unix GeraBibliometriaSciELO.sh
	dos2unix ../tab30/gt30/Atualizatc30issn.sh
	dos2unix ../SetAmbBibliometriaSciELO.txt
	dos2unix ../jcr/titles_gera.sh
	dos2unix artigo-cit_TB.sh
	dos2unix ../co-autor/genco-autor.sh
	dos2unix all_rev_ano_pais.sh
	dos2unix xml/genselbox.sh
	dos2unix ../UnsetAmbBibliometriaSciELO.txt
	
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de bibliometria"
	shopt -u -o histexpand
	./GeraBibliometriaSciELO.sh
	shopt -s -o histexpand
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de bibliometria"
	cd -

# [flx_ProcessaSciELO.txt : 15] Envia bibliometria para servidor de homologacao
# ------------------------------------------------------------------------- #

	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Envio de bibliometria para homologacao"
	cd ../scibiblio/bases/estat/artigo
	
	dos2unix AtualizaBibliometriaSciELO.sh
	
	./AtualizaBibliometriaSciELO.sh

# ------------------------------------------------------------------------- #
# Gerando informacao de termino de processamento de bibliometria
HFIMBIBLI=$(date '+%s')
echo "$HFIMBIBLI" > DURACAO.HFIMBIBLI.txt

# Gerando arquivo com tempo de duracao de processamento de bibliometria para geracao de estatistica em XML
HINIBIBLI=$(cat DURACAO.HINIBIBLI.txt)
HFIMBIBLI=$(cat DURACAO.HFIMBIBLI.txt)

# Gerando arquivo para utilizacao em FechaSciELO ( estBIBLIOxml.sh )
echo $(expr $HFIMBIBLI - $HINIBIBLI) > DURACAO.BIBLI.txt

# Limpando area de trabalho
rm DURACAO.HINIBIBLI.txt
rm DURACAO.HFIMBIBLI.txt
# ------------------------------------------------------------------------- #

	cd -
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Envio de bibliometria para homologacao"
fi

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 18] Processa Xref

	# Passos 7 e 8 assumiram esta funcao
if [ $SCIMAGO ]; then
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de SCImago"
	cd scielo_sjr/shs
	./sjr_run.sh
	cd -
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de SCImago"
fi

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 16] Prepara indices de afiliacao compactos

. FragCnvID2.${SIGLA2}.sh

# [flx_ProcessaSciELO.txt : 17] Envia indices de afiliacao compactos

. FragEnvHM2.${SIGLA2}.sh
# . FragEnvSCL32.${SIGLA2}.sh


# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 19] Processa Google Scholar
if [ $GOOGLESCL ]; then
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Processamento de Google Scholar"
	./googleSchoolar_issueList.sh
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Processamento de Google Scholar"
	
	# [flx_ProcessaSciELO.txt : 20] Empacota resultado de Google Scholar
	echo "Prepara pacote para o Google"
	tar -cvzpf XMLs.tgz output/googleSchoolar
fi

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 21] Prepara dados para calculo de links SciELO.org e etc
if [ $NLINKA -o $SCIELOORG -o $COLLEXIS ]; then
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:INI:] Envio de dados de link"
	./Envia2MedlinePadrao.bat
	echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:] Envio de dados de link"
fi

# ------------------------------------------------------------------------- #
# [flx_ProcessaSciELO.txt : 22] Limpa area de trabalho
# ------------------------------------------------------------------------- #

# [flx_ProcessaSciELO.txt : 23] Envia e-mail de DOC::
echo "<doc>"                                                          > mensagem.txt
echo " <request date=\"$DTEMAIL\">$(cat assunto)</request>"          >> mensagem.txt
echo " <where server=\"${HOMOL}\">${PATH_BASES_HOMOLOG}/*</where>"   >> mensagem.txt
echo " <what></what>"                                                >> mensagem.txt
echo "</doc>"                                                        >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo "---- mensagem original ----"                                   >> mensagem.txt
echo "ASSUNTO: $(cat assunto)"                                       >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo "A equipe OFI,"                                                 >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo "Os arquivos de SciELO ja estao disponiveis no servidor."       >> mensagem.txt
echo "Favor processar o SciELO.${SIGLA2}"                            >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo ""                                                              >> mensagem.txt
echo "Atenciosamente"                                                >> mensagem.txt
# mail -s "DOC:: $(cat assunto)" xxx@xxxxxx.xxx                       < mensagem.txt
mailx -s "$(cat assunto)" ednilson.gesseff@scielo.org francisco.lopes@scielo.org < mensagem.txt
rm mensagem.txt
rm assunto

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') - [:FIM:]  $0 $1 $2 $3 $4 $5"

HFINI=$(date '+%s')
TPROC=$(expr $HFINI - $HINIC)
echo "Tempo decorrido: $TPROC"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=$(pwd)
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/$(echo "$LGDTC" | cut -d/ -f2)
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=$(expr "$LGDTC" : '/[^/]*/\([^/]*\)')
# Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
LGBAS=$(expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)')
# Determina o nome do Shell chamado (sem o eventual path)
LGPRC=$(expr "/$0" : '.*/\(.*\)')

#echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]">>$LGRAIZ/$LGPRD/outs/$LGPRC.tim
unset HINIC
unset HFINI
unset TPROC

TPR="end"
. log
