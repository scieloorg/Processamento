rem GeraArtigo
rem Parametro 1: path producao Scielo

# --------------------------------------
 export CISIS_DIR=cisis
 export INFORMALOG=log/Prova.log
 export PATH=$PATH:.
# --------------------------------------

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

#call batch/CriaDiretorio.bat ../bases-work/artigo
# ---- 20031218 - Chico - start
# call batch/CriaMaster.bat ../bases-work/artigo/artigo
#rm ../bases-work/artigo/artigo_?.xrf
#rm ../bases-work/artigo/artigo_?.mst
# ---- 20031218 - Chico - end
#call batch/CriaMaster.bat ../bases-work/artigo/artigo-cr

# ---- 20031218 - Chico - start
#rem Gera ARTIGO appendando todas as bases de cada titulo
#$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/AppendMasterGizmo.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo',x1,'gizmo/ents2chars',x1,'prc/d1930.prc'/ fi" now >temp/GeraArtigo.bat
# ---- 20040128 - Chico - start
#rem Gera ARTIGOS appendando todas as bases de titulos por letra inicial
#$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/CriaApendaMaster.bat ../bases-work/artigo/artigo_',v68.1,/,'call batch/AppendMasterGizmo.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo_',v68.1,x1,'gizmo/ents2chars',x1,'prc/d1930.prc'/ fi" now >temp/GeraArtigo.bat

rem Gera ARTIGOS appendando todas as bases de titulos por letra inicial
#$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/CriaApendaMaster.bat ../bases-work/artigo/artigo_',v68.1,/,'call batch/AppendMaster.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo_',v68.1,x1,'prc/d1930.prc'/ fi" now >temp/GeraArtigo.bat
# ---- 20040128 - Chico - end
# ---- 20031218 - Chico - end
#batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/title/title lw:9000 pft:call_GeraArtigo.bat
#chmod 700 temp/GeraArtigo.bat
#call temp/GeraArtigo.bat

rem Gera ARTIGO-CR
#$CISIS_DIR/mx $1/serial/title/title lw=9000 "pft=if v50='C' then 'call batch/AppendMaster.bat ../bases-work/',v68,'/',v68,x1,'../bases-work/artigo/artigo-cr',x1,'prc/d1930-cr.prc'/ fi" now >temp/GeraArtigo-cr.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1/serial/title/title lw:9000 pft:call_GeraArtigo-cr.bat
#chmod 700 temp/GeraArtigo-cr.bat
#call temp/GeraArtigo-cr.bat

rem Gera invertigo de ARTIGO e de AUTOR
# ---- 20031218 - Chico - start
rem call batch/GeraInvertido.bat ../bases-work/artigo/artigo fst/artigo.fst ../bases-work/artigo/artigo
rem call batch/GeraInvertido.bat ../bases-work/artigo/artigo fst/author.fst ../bases-work/artigo/author
# ---- 20031218 - Chico - end

rem Gera invertido de ARTIGO-CR e AUTOR-CR
#call batch/GeraInvertido.bat ../bases-work/artigo/artigo-cr fst/artigo.fst ../bases-work/artigo/artigo-cr
#call batch/GeraInvertido.bat ../bases-work/artigo/artigo-cr fst/author.fst ../bases-work/artigo/author-cr

# ---- 20031218 - Chico - start
rem GERA INVERTIDO DE ARTIGO e AUTOR
rem Em $PARTES esta a quatidade de arquivos a serem tratados
echo "Iniciando efetivamente..."
ls ../bases-work/artigo/artigo_?.xrf >temp/lstart.lst
ls ../bases-work/artigo/artigo_?.xrf |wc -l >temp/qtdpartes
read PARTES <temp/qtdpartes

echo "PARTES: $PARTES"

rem Gera um par de invertidos para cada base ARTIGO criada anteriormente
I=1
while [ $I -le ${PARTES} ]
do
 rem extrai o nome do artigo a ser indexado na iteracao corrente e o nome dos invertidos a gerar
 ARQUVEZ=../bases-work/artigo/`head -$I temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
 AUTORVEZ=../bases-work/artigo/au`head -$I temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
 echo "AUTORVEZ: $AUTORVEZ"
 if [ -f $AUTORVEZ".xrf" ]
 then
   # Previne existencia de algum master indevido
   rm $AUTORVEZ.xrf $AUTORVEZ.mst
   #$CISIS_DIR/mx $ARQUVEZ "proc='d*','a998~',mfn(1),'~'" append=$AUTORVEZ -all now
 fi
 echo "Criando master de apoio: $AUTORVEZ"
 $CISIS_DIR/mx $ARQUVEZ "proc='d*','a998~',mfn(1),'~'" append=$AUTORVEZ -all now
 I=`expr $I + 1`
done

echo -n "Chico eh agora: "
read LIXO
# Une os diversos invertidos de artigo em um soh
# --------
# ${PARTES} contem o numero de partes a serem unidas

#  echo -n "$CISIS_DIR/ifmerge ../bases-work/artigo/artigo" >temp/mergear.sh
#  I=1
#  while [ "${I}" -le "${PARTES}" ]
#  do
#    ARQUVEZ=../bases-work/artigo/`head -${I} temp/lstart.lst |tail -1|cut -d"/" -f"4"|cut -d"." -f"1"`
#    echo " $ARQUVEZ \\">>temp/mergear.sh
#    I=`expr ${I} + 1`
#  done
#  echo    " +mstxrf tell=100000">>temp/mergear.sh

#  chmod 755 temp/mergear.sh
#  temp/mergear.sh

# Une os diversos invertidos de autor em um soh (gerando um master para apontar tudo)
# --------

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

# --------

rem Limpa area de trabalho
# rm temp/lstart.lst temp/qtdpartes temp/artigo.mst temp/artigo.xrf
# rm temp/mergear.sh temp/mergearau.sh
# rm ../bases-work/artigo/artigo_?.cnt ../bases-work/artigo/artigo_?.ifp ../bases-work/artigo/artigo_?.l0? ../bases-work/artigo/artigo_?.n0?
# rm ../bases-work/artigo/auartigo_?.*

# ---- 20031218 - Chico - end
