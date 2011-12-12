rem GeraArtigo
rem Parametro 1: path producao Scielo

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

call batch/CriaDiretorio.bat ../bases-work/artigo
rm ../bases-work/artigo/artigo_?.xrf
rm ../bases-work/artigo/artigo_?.mst
call batch/CriaMaster.bat ../bases-work/artigo/artigo-cr

rem Gera ARTIGOS appendando todas as bases de titulos por letra inicial
$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/CriaApendaMaster.bat ../bases-work/artigo/artigo_',v68.1,/,'call batch/AppendMaster.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo_',v68.1,x1,'prc/d1930.prc'/ fi" now >temp/GeraArtigo.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/title/title lw:9000 pft:call_GeraArtigo.bat
chmod 700 temp/GeraArtigo.bat
call temp/GeraArtigo.bat

rem Gera ARTIGO-CR
$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/AppendMaster.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo-cr',x1,'prc/d1930-cr.prc'/ fi" now >temp/GeraArtigo-cr.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/title/title lw:9000 pft:call_GeraArtigo-cr.bat
chmod 700 temp/GeraArtigo-cr.bat
call temp/GeraArtigo-cr.bat

rem Gera invertido de ARTIGO-CR e AUTOR-CR
call batch/GeraInvertido.bat ../bases-work/artigo/artigo-cr fst/artigo.fst ../bases-work/artigo/artigo-cr
call batch/GeraInvertido.bat ../bases-work/artigo/artigo-cr fst/author.fst ../bases-work/artigo/author-cr

rem GERA INVERTIDO DE ARTIGO e AUTOR
rem Em $PARTES esta a quatidade de arquivos a serem tratados
ls ../bases-work/artigo/artigo_?.xrf >temp/lstart.lst
ls ../bases-work/artigo/artigo_?.xrf |wc -l >temp/qtdpartes
read PARTES <temp/qtdpartes

rem Gera um par de invertidos para cada base ARTIGO criada anteriormente
I=1
while [ ${I} -le ${PARTES} ]
do
 rem extrai o nome do artigo a ser indexado na iteracao corrente e o nome dos invertidos a gerar
 ARQUVEZ=../bases-work/artigo/`head -${I} temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
 AUTORVEZ=../bases-work/artigo/au`head -${I} temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
 call batch/GeraInvertido.bat ${ARQUVEZ} fst/artigo.fst ${ARQUVEZ}
 call batch/GeraInvertido.bat ${ARQUVEZ} fst/author.fst ${AUTORVEZ}
 if [ -f $AUTORVEZ".xrf" ]
 then
   # Previne existencia de algum master desincronizado - # MFN
   rm $AUTORVEZ.xrf $AUTORVEZ.mst
 fi
 echo "Criando master de apoio: $AUTORVEZ"
 $CISIS_DIR/mx $ARQUVEZ "proc='d*','a998~',mfn(1),'~'" append=$AUTORVEZ -all now
 I=`expr $I + 1`
done

rem Une os diversos invertidos de artigo em um soh
rem --------
rem ${PARTES} contem o numero de partes a serem unidas

  echo -n "$CISIS_DIR/ifmerge ../bases-work/artigo/artigo" >temp/mergear.sh
  I=1
  while [ "${I}" -le "${PARTES}" ]
  do
    ARQUVEZ=../bases-work/artigo/`head -${I} temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
    echo " $ARQUVEZ \\">>temp/mergear.sh
    I=`expr ${I} + 1`
  done
 echo    " +mstxrf tell=100000">>temp/mergear.sh

  chmod 755 temp/mergear.sh
  temp/mergear.sh

rem Une os diversos invertidos de autor em um soh - gerando um master para apontar tudo
rem --------

  echo -n "$CISIS_DIR/ifmerge ../bases-work/artigo/author" >temp/mergearau.sh
  I=1
  while [ "${I}" -le "${PARTES}" ]
  do
    AUTORVEZ=../bases-work/artigo/au`head -${I} temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
    echo " $AUTORVEZ \\">>temp/mergearau.sh
    I=`expr $I + 1`
  done
  echo    " +mstxrf tell=100000">>temp/mergearau.sh

  chmod 755 temp/mergearau.sh
  temp/mergearau.sh

rem --------

rem Coloca a informacao de redirecao na tag e formato esperados
rem Retagando e formatando
mv ../bases-work/artigo/artigo.mst temp/artigo.mst
mv ../bases-work/artigo/artigo.xrf temp/artigo.xrf
call batch/CriaMaster.bat ../bases-work/artigo/artigo
$CISIS_DIR/mx temp/artigo "proc='d32701a32701~',right(v32701^*,8),'^m',v32701^m,'~'" append=../bases-work/artigo/artigo -all now

rem Limpa area de trabalho
rm temp/artigo.mst temp/artigo.xrf
rm ../bases-work/artigo/artigo_?.cnt ../bases-work/artigo/artigo_?.ifp ../bases-work/artigo/artigo_?.[l,n]0?
rm ../bases-work/artigo/auartigo_?.*

# rm temp/lstart.lst temp/qtdpartes
# rm temp/mergear.sh temp/mergearau.sh
