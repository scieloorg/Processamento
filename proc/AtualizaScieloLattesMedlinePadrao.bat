echo "Inicio de processamento ${0} em `date '+%Y%m%d %H%M%D'`"
echo "Ativando NLINKS e LATTES"
./GeraBasesExternasPadrao.bat

export PATH=$PATH:.
export INFORMALOG=log/AtualizaScieloLattesMedline.log
export CISIS_DIR=cisis

rem Encadeia a chamada a atualizacao da bibliometria
echo ""
echo " Atualizando a bibliometria"
echo ""
cd ../scibiblio/bases/estat/artigo/
./AtualizaBibliometriaSciELOsp.sh
cd ../../../../proc

echo ""
echo " ATUALIZACAO SCIELO-SP CONCLUIDA"
echo ""
echo " A LIMPEZA DO DIRETORIO SERIAL PODE SER EFETUADA"
echo ""
rm -rf ../serial/*

# ------------------------------------------------------------------------- #
# Prepara dados para SciELO-LOG
# ATENCAO = ISOs ja gerados na execucao de Evnia2MedlinePadrao

echo "Inicia empacotamento"
# Gera a estrutura de "deposito" dos arquivos e coloca individuos para posterior transferencia a scielo-log em Tambore
mkdir -p temp/bases/accesslog/log_scielosp/issue
mkdir -p temp/bases/accesslog/log_scielosp/title
mkdir -p temp/bases/accesslog/log_scielosp/trab

# Manda copia dos dados para a estrutura de deposito
cp temp/transf2medline/issue.iso  temp/bases/accesslog/log_scielosp/issue
cp temp/transf2medline/titsci.iso temp/bases/accesslog/log_scielosp/title
cp temp/transf2medline/artigo.iso temp/bases/accesslog/log_scielosp/trab

echo "Finda empacotamento"

cat >mensagem.txt <<!
A equipe ITI,

Atualizacao do sitio oficial SciELO.SP (http://www.scielosp.org/) de `date +%d/%m/%Y` esta apta a ser efetuada.
Por favor, efetuem o processo informando sua conclusao a scielo@listas.bireme.br

Diretorios sob SciELOhm1:/home/scielosp/www/bases (e subdiretorios) participantes da atualizacao:
 -artigo;
 -cited;
 -doi;
 -iah;
 -img;
 -issue;
 -lattes;
 -medline;
 -newissue;
 -pdf;
 -related;
 -title; e
 -translation

Diretorios sob SciELOhm1:/home/scielosp/www/bases que NAO participam da atualizacao:
  ftp; iso; logdia; stop; tab; temp; user

Os dados de Google Scholar, relativos ao SciELO.SP, estao disponiveis para transferencia em:
  SciELOpx1:/bases/spa.000/proc/scielo_gsc/output/googleSchoolar/

Os dados para scielo-log (Tambore) estao disponiveis para transferencia sob:
  SciELOpx1:/bases/spa.000/proc/temp/bases

 Themis T. Coelho / Marcelo M. Bottura / Francisco Jose Lopes
 themis.coelho@bireme.org / marcelo.bottura@bireme.org / francisco.lopes@bireme.org
 OFI - Operacao de Fontes de Informacao
 ramal: 9817
!

echo "mail -s \"[SciELO-SP] Suporte atualizar o sitio oficial do SciELO-SP\" suporte@bireme.br -c scielo@listas.bireme.br"
mail -s "[SciELO-SP] Suporte atualizar o sitio oficial do SciELO-SP" suporte@bireme.br -c scielo@listas.bireme.br -b francisco.lopes@bireme.org <./mensagem.txt
rm mensagem.txt

echo "Prepara dados de processamento e gera relatorios"
./StatSciELO.sh SP

date +%s > ../Atualizar_OK.txt

# Operacoes internas ao OFI

echo "`date '+%Y%m%d %H%M%S'` SciELOsp">collexis.scielosp

cat >cmd.ftp <<!
open serverafi
user cdrom cdr,./
cd /bases/sci.000/sci.sci
put collexis.scielosp
bye
!

ftp -i -n -v < cmd.ftp

cat >mensagem.txt <<!
A equipe OFI,

Dados para geracao do XML da FI SciELO.sp - col_scielosp.xml
disponiveis desde `date '+%Y%m%d %H%M%S'` em ServerAFI:
   /bases/lnk.000/art.spa/
   /bases/lnk.000/tit.spa/

Por favor, efetuar o processamento de Collexis para a FI

 Themis T. Coelho / Marcelo M. Bottura / Francisco J. Lopes
 OFI - Operacao de Fontes de Informacao
 themis.coelho@bireme.org / marcelo.bottura@bireme.org / francisco.lopes@bireme.org
 Ramal: 9817
!
mail -s "OS:: [SciELO-SP] OFI processar collexis `date '+%d/%m/%Y'`" ofi@listas.bireme.br <./mensagem.txt
rm mensagem.txt

cat >mensagem.txt <<!
A equipe OFI,

Dados para processamento de nLinks de SciELO.sp disponiveis desde `date '+%Y%m%d %H%M%S'` em ServerAFI:
   /bases/lnk.000/art.spa/
   /bases/lnk.000/b4c.spa/
   /bases/lnk.000/iss.spa/
   /bases/lnk.000/tit.spa/

Por favor, efetuar o processamento de nLinks para a FI

 Themis T. Coelho / Marcelo M. Bottura / Francisco J. Lopes
 OFI - Operacao de Fontes de Informacao
 themis.coelho@bireme.org / marcelo.bottura@bireme.org / francisco.lopes@bireme.org
 Ramal: 9817
!
mail -s "OS:: [SciELO-SP] OFI processar nLinks `date '+%d/%m/%Y'`" ofi@listas.bireme.br <./mensagem.txt
rm mensagem.txt

cat >mensagem.txt <<!
A equipe OFI,

Dados para processamento de iAHLinks de SciELO.sp disponiveis desde `date '+%Y%m%d %H%M%S'` em ServerAFI:
   /bases/lnk.000/art.spa/
   /bases/lnk.000/b4c.spa/
   /bases/lnk.000/iss.spa/
   /bases/lnk.000/tit.spa/

Por favor, efetuar o processamento de iAHLinks para a FI

 Themis T. Coelho / Marcelo M. Bottura / Francisco J. Lopes
 OFI - Operacao de Fontes de Informacao
 themis.coelho@bireme.org / marcelo.bottura@bireme.org / francisco.lopes@bireme.org
 Ramal: 9817
!
mail -s "OS:: [SciELO-SP] OFI processar iAHLinks `date '+%d/%m/%Y'`" ofi@listas.bireme.br <./mensagem.txt
rm mensagem.txt

echo "Termino de processamento ${0} em `date '+%Y%m%d %H%M%D'`"

