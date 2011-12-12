echo 'GeraBibliometriaPadrao.sh 1.0 full+mdl'
cd /usr/local/scielosp/procs/biblio
echo 'GeraBibliometriaPadrao.sh 1.1 full+mdl' >advisor.txt
echo 'process started' >>advisor.txt
date >>advisor.txt
date
./gen_biblio.sh FULL MDL
date
./step20.sh
cd /usr/scielosp/procs/biblio
echo 'process finished ' >>advisor.txt
date >>advisor.txt
echo 'end process'

cat >mensagem.txt <<!
GerabibliometriaPadrao.sh acabou!
!
mail -s "[SciELO-SP] Fim GeraBibliometriaPadrao.sh" ednilson.gesseff@scielo.org < mensagem.txt
rm -f mensagem.txt

# /usr/local/scielosp/scielo-prod/proc/emailscielo3 "Termino de GeraBibliometriaPadrao.sh"
