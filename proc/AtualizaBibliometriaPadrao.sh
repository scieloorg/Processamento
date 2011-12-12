PROOT=/usr/scielosp/procs; export PROOT
DBROOT=/usr/scielosp/prod; export DBROOT
SHROOT=/usr/local/bin/cisis; export DBROOT
WBROOT=/mnt/scielo-online/scielosp/www/bases; export WBROOT
WBROOTOLD=/home/scielosp/www/bases; export WBROOTOLD
date
echo 'disconnecting site db'
$SHROOT/mx in=$PROOT/biblio/stopoff2.in
$SHROOT/mx in=$PROOT/biblio/stopoff2b.in
cd $DBROOT/bib
if
  [ -f ./bib5cit.mst ]
then
#  echo 'disabled'
  rm ./bib5cit.mst
  rm ./bib5cit.xrf
fi
if
  [ -f ./biba2h.mst ]
then
  rm ./biba2h.mst
  rm ./biba2h.xrf
fi
if
  [ -f ./biba2c.mst ]
then
#  echo 'disabled'
  rm ./biba2c.mst
  rm ./biba2c.xrf
fi
echo 'copying (/bib) files'
cp -R $DBROOT/bib $WBROOT/.
cd $WBROOT/artigo
cp $DBROOT/artigo/isscitt*.* .
cp $DBROOT/artigo/summary*.* .
echo 'finished copy procedure'
echo 'reconnecting site db'
$SHROOT/mx in=$PROOT/biblio/stopon2.in
$SHROOT/mx in=$PROOT/biblio/stopon2b.in
cp $DBROOT/bib/stop2.mst $WBROOT/stop/stop.mst
cp $DBROOT/bib/stop2.xrf $WBROOT/stop/stop.xrf
date

date
echo 'disconnecting site db'
$SHROOT/mx in=$PROOT/biblio/stopoff2old.in
$SHROOT/mx in=$PROOT/biblio/stopoff2bold.in
cd $DBROOT/bib
echo 'copying (/bib) files'
cp -R $DBROOT/bib $WBROOTOLD/.
cd $WBROOTOLD/artigo
cp $DBROOT/artigo/isscitt*.* .
cp $DBROOT/artigo/summary*.* .
echo 'finished copy procedure'
echo 'reconnecting site db'
$SHROOT/mx in=$PROOT/biblio/stopon2old.in
$SHROOT/mx in=$PROOT/biblio/stopon2bold.in
cp $DBROOT/bib/stop2.mst $WBROOTOLD/stop/stop.mst
cp $DBROOT/bib/stop2.xrf $WBROOTOLD/stop/stop.xrf
date

cat >mensagem.txt <<!
À equipe SciELO,

Atualização da bibliometria SciELO-SP no sítio oficial (http://www.scielosp.org/bib2jcr.htm) concluída.
Por favor efetuem testes de comprovação

 Ednilson Gessef / Francisco Lopes
 mailtlson.gessef@scielo.org  | http://www.scielo.org
 Phone: +55 (11) 3369-4085 
!
mail -s "Atualizacao da bibliometria do SciELO-SP" scielo-lista@scielo.org <  mensagem.txt
rm mensagem.txt

# /usr/local/scielosp/scielo-prod/proc/emailscielo3 "Termino de AtualizaBibliometriaPadrao.sh"
