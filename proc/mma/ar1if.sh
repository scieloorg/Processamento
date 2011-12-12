#!/bin/bash

export HOMOL=scielohm1
export TESTE=scielo3

# ATENCAO: Esta rotina so deve ser utilizada em processamento de ORG, prefira genAH.sh

echo === BEGIN ar1if.sh ===
date


#
## step 0 - Prepara tabelas
#
# Montagem da tabela a partir de http://w3.datasus.gov.br/DATASUS/datasus.php?area=361A3B372C2D3690E6FG16HIJd3L1M0N&VAba=5&VInclude=../site/din_sist.php&VSis=1&VCoit=3690&VI=Munic�pio
# C:\mma\2007>mx CADUF "fst=1 0 v1/v2" fullinv=CADUF
# C:\mma\2007>mx CADMUN join=CADUF,102:2=v14 "proc='d*a1|'v1'|a2|'v7'|a3|'v6'|a4|'v102'|a5|'v3'|a6|'v102' - 'v6'|a7|'v2'|" bool=ATIVO -all now iso=tabmunic.iso
# C:\mma\2007>mx CADMUN join=CADUF,102:2=v14 "join=CADUF,202:2=v24.2" "proc='d6d7a6|'left(v6,instr(v6,' (')-1)'|a7|'left(v7,instr(v7,' (')-1)'|'" "proc='d*a1|'v1'|a2|'v7'|a3|'v6'|a4|'v102'|a5|'v3'|a6|'v102' - 'v6'|a7|'v2'|a17|'v202'|a24|'v24'|'" bool=TRANS -all now iso=tabmunic2.iso

## Tabela de Municipios BR

mx iso=tabs/tabmunic.iso -all now create=tabmun gizmo=$TABS/g850ans tell=1000
mx iso=tabs/tabmunic2.iso -all now append=tabmun gizmo=$TABS/g850ans tell=1000

mx tabmun loop=1417 now
echo "1020 tabmun"

##  tira apostrofes e crases de Pau D'alho etc 

mx tabmun  uctab=ansi "proc='<9 0>'replace(v3,'\`',\`'\`)'</9>'" "proc=e1:=instr(v9,\`'\`),,if e1>0 then '<8 0>'replace(v9,\`'\`,'')'</8>','<8 0>'left(v9,e1-1)mid(v9,e1+1,1)' 'right(v9,size(v9)-e1)'</8>' fi" "proc='d9<8 0>'v9'</8>'" -all now create=tabm


## Tabela de regioes brasileiras
mx seq=../tabs/tabregiaoBR.seq create=../tabs/tabregiaoBR -all now
mx ../tabs/tabregiaoBR "proc='Gsplit/clean=4=,'" "fst=1 0 (v4/)" fullinv=../tabs/tabregiaoBR

## Tabela de Paises - match Brasil
#AE|EMIRADOS �RABES UNIDOS|UNITED ARAB EMIRATES|EMIRATOS ARABES UNIDOS

## Tabela de UF's BR - implementar BR no campo 1 - match AC, Brasil
#DF|Distrito Federal|Federal District|Districto Federal

## Tabela de AreasGeo - nome de areas/acidentes geograficos ainda nao traduzidos - match AC, Brasil
##|reserva
##|floresta

mx seq=tabs/tabpais.txt -all now create=tabp "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|"
mx seq=tabs/tabuf.txt   -all now create=tabu "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|"
mx seq=tabs/tabgeo.txt  -all now create=tabg "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|"

# Exclusoes da tabela de municipios brasileiros
mx ../tabs/tablarg create=tabs/tablarg "fst=1 0 if v20<>'BR' then v1 fi" fullinv=tabs/tablarg actab=$TABS/acans.tab uctab=ansi

## Tabela X = UF's BR + AreasGeo
## Tabela X = tabu    + tabg    
##
mx tabu            -all now create=tabx
mx tabg            -all now append=tabx


## Inverte codigo/valor(es)
#
mx tabp   uctab=ansi "fst=1 0 v1/(v8/)"   fullinv=tabp
mx tabu   uctab=ansi "fst=1 0 v1/(v8/)"   fullinv=tabu
mx tabx   uctab=ansi "fst=1 0    (v8/)"   fullinv=tabx

## Cria tabloc
#

# v11   - pais

# v12^u - uf
# v12^x - pais

# v13^u - mun
# v13^v - uf
# v13^x - 

mx tabp uctab=ansi "proc=(if p(v8) then '<11 0>'v8'</11>'                                                                fi)" -all now create=tabloc "proc=if p(v11) then 'a10/tabp^m'mfn(1)'/' fi"

mx tabu uctab=ansi "proc=(if p(v8) then '<12 0>'v8'^u'v1[1]                                '^x'f(l->tabp(v8),1,0)'</12>' fi)" -all now   copy=tabloc "proc=if p(v12) then 'a10/tabu^m'mfn(1)'/' fi" "proc='='f( 1000+mfn,1,0)" 

mx tabm uctab=ansi "proc=(if p(v8) then '<13 0>'v8'^u'v4[1]'^v'ref->tabu(l->tabu(v4[1]),v2)'^x'f(l->tabx(v8),1,0)'</13>' fi)" -all now   copy=tabloc "proc=if p(v13) then 'a10/tabm^m'mfn(1)'/' fi" "proc='='f(10000+mfn,1,0)" 

1020 tabloc



## Tabela de Areas - politicas - cravado em ar12fst.pft - 4 levels - implementar indicador pre/post
##|region
##|country
##|state
##|city
#[tabs/ar12fst.pft]
#    /* countries - as mentioned
#    */
#    (if p(v11) then v11/ fi)
#    
#    /* states - preceeded/followed by country name or the state word
#    */
#    (if p(v12) then 
#        if v13^2='0' then v12^* / fi
#        v12^*' Brasil'/v12^*' Brazil'/        
#        'estado de 'v12^*         /  'estado da 'v12^*         /  'estado do 'v12^*         /  'state of 'v12^*         /  v12^*' state'         /
#        'estado de 'v12^*' Brasil'/  'estado da 'v12^*' Brasil'/  'estado do 'v12^*' Brasil'/  'state of 'v12^*' Brazil'/  v12^*' state'' Brazil'/
#     fi
#    )
#
#    /* cities - preceeded/followed by country name or the state word
#    */
#    (if p(v13) then 
#        'municipio de '     v13^* /  'cidade de ' v13^* /  v13^*' city'  /  v13^*' municipality'  /
#        'municipios de '    v13^* /  'cidades de 'v13^* /  v13^*' cities'/  v13^*' municipalities'/
#        'municipio '        v13^* /  'cidade '    v13^* /
#        'municipios '       v13^* /  'cidades '   v13^* /
#        'municipality of '  v13^* /  
#        'municipalities of 'v13^* /  
#        
#        v13^*' 'v13^u/
#        v13^*' 'v13^v/
#        
#        v13^*' 'v13^u' Brasil'/v13^*' 'v13^u' Brazil'/
#        v13^*' 'v13^v' Brasil'/v13^*' 'v13^v' Brazil'/
#
#        v13^*' estado de 'v13^v         /   v13^*' estado da 'v13^v         /   v13^*' estado do 'v13^v         /   v13^*' state of 'v13^v         /   v13^*' 'v13^v' state'         /
#
#        v13^*' estado de 'v13^v' Brasil'/   v13^*' estado da 'v13^v' Brasil'/   v13^*' estado do 'v13^v' Brasil'/   v13^*' state of 'v13^v' Brazil'/   v13^*' 'v13^v' state'' Brazil'/
#     fi
#    )
#end ar12fst.pft

mx seq=tabs/tabarea.txt -all now create=taba "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|"

mx tabloc uctab=ansi "fst=1 0 @tabs/ar12fst.pft" fullinv=tabloc tell=3000
mx taba   uctab=ansi "fst=1 0 v2"           fullinv=taba



## Gizmo Ansi to Uppercase + remove comma 
#
mx iso=tabs/gansuc.iso -all now create=gansuc+comma
mx null count=1 "proc='a1/,/'" -all now append=gansuc+comma



#
## step 1 - Extrai dado em ingles (titulo se e1=0, ou titulo, resumo e keywords se e1=1)
#

#lind/mx null count=1 create=xart2 tell=1000
# [CHICO] com count=1 desemparelha de um registro os MFNs da artigos
mx null count=0 create=xart2 tell=1000
#lind/mx cipar=artigo.cip artigo bool=TP=H "proc=if p(v32701) then 'R'v32701^*','v32701^m fi" uctab=ansi "proc=e1:=1,@tabs/ar1aif.pft" -all now append=xart2 tell=1000
mx ../iso/artigos uctab=ansi "proc=e1:=1,@tabs/ar1aif.pft" -all now append=xart2 tell=1000


#
## step 2 - Marca areas geograficas com Gsplit=2=6words/if=tabloc (vide tabs/ar1bif.pft)
#
#[tabs/ar1bif.pft]
#  /* get input
#  */
#  proc('<2 0>'v12'. 'v83'. 'v85'</2>')
#  
#  /* apply "ansi upper case" + delete comma
#     (gansna because of serverafi)
#  */
#  proc('Ggansuc+comma,2')
#
#  /* extract 6words into repeatable field
#  */
#  proc('Gsplit=2=6words/if=tabloc')
#  proc('Gsplit=2')

## Processamento abortou com +++ 8900000 fatal: mx/proc/format execution error
#lind/mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now create=xar2 tell=50000
## Processamento em duas partes
# lind/mx null count=1 create=xaa2
# lind/mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now   copy=xaa2 tell=1001 to=50000
# lind/mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now   copy=xaa2 tell=1002 from=50001 to=57175

mx xart2 uctab=ansi "proc='d2d12d83d85<2 0>'v12'. 'v83'. 'v85'</2>'" "proc='Gmark/2/AREA=tabloc" "proc='Gmarx/2/AREA =3:^k&key^m&mfn'" "proc='d2d3'(if p(v3) then '<2 0>'v3^k'^m'v3^m'</2>' fi)"  proc=@tabs/ar1d.pft "proc='d2d3'(if p(v2) then '<3 0>'v2'</3>',if iocc>33 then break fi fi)" proc=@tabs/ar1f.pft proc=@tabs/ar1g2.pft  proc=@tabs/ar1h.pft -all now create=xar2 tell=1000 
   
echo "1020 xar2"


#
## step 3 - Lista resultado
#

mxtb xar2 create=x5 "60:(v5^*/)" class=10000 tell=5000
msrt x5 10 v998
mx x5 "pft=f(val(v999),8,0),x4,v1/" now count=20

mx xar2 uctab=ansi "fst=1 0 '.artigos'/,(if p(v5) then v5^*/'.artigos com area geografica'/,if v5^t='tabm' then '.area=municipio'/'m='v5^*/'g='v5^g/ else if v5^t='tabu' then '.area=uf'/'u='v5^*/ else if v5^t='tabp' then '.area=pais'/'p='v5^*/ fi fi fi fi)" fullinv=xar2 tell=10000

# Stdout top results 
mx dict=xar2 k1=m= k2=m= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=u= k2=u= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=p= k2=p= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=. k2=.                        "pft=f(val(v1^t),8,0),x4,v1^*/"    now


## Resultado completo 
# extraido por formato (tabs/ar1.pft)
# carregado em mf
# invertido por PID; nomes; m=mun u=uf p=pais; g=geo; tipo access point t=m ou t=u ou t=p
#
mx xar2 uctab=ansi pft=@tabs/ar1.pft lw=32000 now tell=1000000>xa.txt
mx seq=xa.txt -all now create=xa 
mx xa uctab=ansi "fst=1 0 'pid='v2/,v4/v5/v6/v7/v8/v9/v10/v11/v12/,|m=|v4/,|u=|v5/,|p=|v6/,|g=|v8/,'t='v10,v11,v12" fullinv=xa tell=5000
echo "1020 xa"

# Stdout top results 
mx dict=xa k1=t= k2=t= "pft=f(val(v1^t),8,0),x4,v1^*/" now

# Sequential output - transferir a MMA (a/c PHAS): xa?.txt
mx xa btell=0 t=m -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xam.txt
mx xa btell=0 t=u -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xau.txt
mx xa btell=0 t=p -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xap.txt

# Municipios brasileiros
if [ -f "xamBR.xrf" ]
then 
  rm xamBR.*
fi
mx seq=xam.txt -all now create=xam
# Municipios brasileiros sem duvidas grandes
mx xam actab=$TABS/acans.tab uctab=ansi "proc=if l(['tabs/tablarg']s(mpu,v3,mpl))>0 then 'd*' fi" append=xamBR -all now
echo "1020 xam"
mx seq=xau.txt -all now create=xau
echo "1020 xau"
mx seq=xap.txt -all now create=xap
echo "1020 xap"


## Controle - transferir a serverofi.bireme.br: resumo xax.txt + xar2.* para browse da base artigo*
#
#  'ARTIGOS|'                    f(npost->xar2('.ARTIGOS'),1,0)                                                  /
#  'ARTIGOS COM AREA GEOGRAFICA|'f(npost->xar2('.ARTIGOS COM AREA GEOGRAFICA'),1,0)                              /
#  'ARTIGOS COM MUNICIPIO|'      f(npost->xar2('.AREA=MUNICIPIO'),1,0)             '|'ref->xam(1,f(maxmfn-1,1,0))/
#  'ARTIGOS COM UF|'             f(npost->xar2('.AREA=UF'),1,0)                    '|'ref->xau(1,f(maxmfn-1,1,0))/
#  'ARTIGOS COM PAIS|'           f(npost->xar2('.AREA=PAIS'),1,0)                  '|'ref->xap(1,f(maxmfn-1,1,0))/

mx null count=1 pft=@tabs/ar1x.pft lw=999 now >xax.txt
cat xax.txt

# ------------------------------------------------------------------------- #
# Inverte por areas geograficas

echo "[INI] Inversao por areas geograficas para SciELO.ORG"
echo "(if v5^t='tabm' then |AM_|v5^*/ fi)"  >../tabs/ageo.pft
echo "(if v5^t='tabu' then |AS_|v5^*/ fi)" >>../tabs/ageo.pft
echo "(if v5^t='tabp' then |AC_|v5^*/ fi)" >>../tabs/ageo.pft

if [ -f "arGeo.iy0" ]
then
  rm arGeo.iy0
fi

# Inverte por Pais (AC_), Estado (AS_), e Cidade (AM_)
 mx xar2 "fst=82 0 @../tabs/ageo.pft" actab=$TABS/acans.tab uctab=$TABS/ucans.tab fullinv=arGeo tell=5000
 mkiy0 arGeo
 rm arGeo.cnt arGeo.n0? arGeo.ly? arGeo.iyp


# Inverte por municipio
# mx xar2 "fst=444 0 (if v5^t='tabm' then v5^*/ fi)" fullinv=wmun tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab
# Inverte por unidade federativa
# mx xar2 "fst=444 0 (if v5^t='tabu' then v5^*/ fi)" fullinv=wuni tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab
# Inverte por pais
# mx xar2 "fst=444 0 (if v5^t='tabp' then v5^*/ fi)" fullinv=wpai tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab

echo "[FIM] Inversao por areas geograficas para SciELO.ORG"
echo "[INI] Gera dados para servico web"


 mx xamBR "fst=1 0 v1" fullinv=xamBR
 mx dict=xamBR,8801,8802 "join=xamBR=(|mfn=|v8802^m/)" "proc='d32001'" -all now create=x
# #mx x "join=../tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc='d32001'" "proc=(if p(v6) then if v106[1]:s('~'v6'~') then else proc('d106a106|'v106[1],'~'v6'~','|') fi fi)" "proc='Gsplit/clean=106=~'" "proc=(if p(v12) then if v112[1]:s('~'v12'~') then else proc('d112a112|'v112[1],'~'v12'~','|') fi fi)" "proc='Gsplit/clean=112=~'" -all now create=xx
# mx x "join=../tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)" "proc='s20'" "proc=|<200 0>|v20|</200>|" "proc='Gtabs/gcharurl,200'" lw=0 pft=@p1.pft from=1511

 mx x "join=../tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)" "proc='s20'" "proc=|<200 0>|v20|</200>|" "proc='G$TABS/gansna,200'" "proc='Gtabs/gcharurl,200'" "proc='d*a880|'v1[1]'|<1 0>',@areasgeo1.pft,'</1>'" create=areasgeoBR -all now

if [ -f "areasgeoBR.iy0" ]
then
 rm areasgeoBR.iy0
fi

 mx areasgeoBR "fst=1 0 v880^c,v880^*/,v880^*/,v880^c" fullinv=areasgeoBR
 mkiy0 areasgeoBR
 rm areasgeoBR.cnt areasgeoBR.ly? areasgeoBR.n0? areasgeoBR.iyp


# ------------------------------------------------------------------------- #
#  Guardar esta geracao de indice geografico para uso futuro no ORG
## Gera invertido de areas geograficas para iAH - apenas para SciELO Brasil
## - nao transferir ate processamento de instancias ser produto de .org
# echo "Gera indice de area geograficas para iAH do SciELO.BR"
# mx ../iso/art.scl/artigo "fst=1 0 v880" fullinv=xpids tell=5000
# if [ -f "artscl_AG.iy0" ]
# then
#   rm artscl_AG.iy0
# fi
# mx x "join=../tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)"  "fst=1 1000 if l->xpids(v8801^*'^c'v8801^c)>0 then '/'f(l->xpids(v8801^*'^c'v8801^c),1,0)'/',(if p(v20) then 'Pais 'v20^p/,'Regiao 'v20^r/,'UF 'v20^u/,v20^m/ fi) fi" uctab=ansi actab=$TABS/acans.tab master=../iso/art.scl/artigo fullinv=artscl_AG tell=1000
# rm xpids.*
# mkiy0 artscl_AG 
# rm artscl_AG.cnt artscl_AG.ly? artscl_AG.n0? artscl_AG.iyp
# ------------------------------------------------------------------------- #


 # Transfere resultados de areas geograficas
 scp areasgeoBR.* trigramas:/bases/similar/SciELOgeo
 
 scp areasgeoBR.mst $HOMOL:/home/scielo/www/bases/areasgeo/areasgeo.mst
 scp areasgeoBR.xrf $HOMOL:/home/scielo/www/bases/areasgeo/areasgeo.xrf
 scp areasgeoBR.iy0 $HOMOL:/home/scielo/www/bases/areasgeo/areasgeo.iy0
 scp areasgeoBR.mst $HOMOL:/home/scielosp/www/bases/areasgeo/areasgeo.mst
 scp areasgeoBR.xrf $HOMOL:/home/scielosp/www/bases/areasgeo/areasgeo.xrf
 scp areasgeoBR.iy0 $HOMOL:/home/scielosp/www/bases/areasgeo/areasgeo.iy0
 # Facilita a vida dos desenvolvedores
 scp areasgeoBR.mst $TESTE:/home/scielo/www/bases/areasgeo/areasgeo.mst
 scp areasgeoBR.xrf $TESTE:/home/scielo/www/bases/areasgeo/areasgeo.xrf
 scp areasgeoBR.iy0 $TESTE:/home/scielo/www/bases/areasgeo/areasgeo.iy0
 scp areasgeoBR.mst $TESTE:/home/scielosp/www/bases/areasgeo/areasgeo.mst
 scp areasgeoBR.xrf $TESTE:/home/scielosp/www/bases/areasgeo/areasgeo.xrf
 scp areasgeoBR.iy0 $TESTE:/home/scielosp/www/bases/areasgeo/areasgeo.iy0
# Prover transferencia para ftp Chile, Cuba, ...

echo "[FIM] Gera dados para servico web"

# ------------------------------------------------------------------------- #
# Gera lista de URL para verificacao

# Tabela Auxiliar de denominacao de municipios
echo "Bataipora|Bataypora"                             >city_alt.seq
echo "Jamari|Candeias do Jamari"                      >>city_alt.seq
echo "Itamaraca|Ilha_de_Itamaraca"                    >>city_alt.seq
echo "Picarras|Balneario_Picarras"                    >>city_alt.seq
mx seq=city_alt.seq create=tabs/city_alt -all now

#cancela lista de corre��o
mx null count=0 create=tabs/city_alt -all now
rm city_alt.seq

# Garante conversao de caracteres como necessario para montagem de URL
echo " |_"  >gcharurl.seq
echo "'"   >>gcharurl.seq
mx seq=gcharurl.seq create=tabs/gcharurl -all now
rm gcharurl.seq

mx xa btell=0 t=m lw=999 gizmo=$TABS/gansna gizmo=tabs/city_alt gizmo=tabs/gcharurl,4 "pft=v8,'|http://tabnet.datasus.gov.br/tabdata/cadernos/',v5,'/',v5,'_',v4,'_Geral.xls'/" now | sort -u > URLDATASUS2v.txt

# Efetua a verificacao das URLs DATASUS e lista as ok e as nao ok
java -cp ../tpl.org/CheckLinksII.jar checkLinks.FileCheckUrls URLDATASUS2v.txt ../outs/URLDATASUS_ok.txt ../outs/URLDATASUSnok.txt
if [ `wc -l ../outs/URLDATASUSnok.txt |cut -d " " -f "1"` -ne "0" ]
then
  echo "Lista de documentos nao encontrados ao testar o link:"   > mensagem.txt
  echo ""                                                       >> mensagem.txt
  echo "http://tabnet.datasus.gov.br/tabdata/cadernos/"         >> mensagem.txt
  echo ""                                                       >> mensagem.txt
  echo ""                                                       >> mensagem.txt
  cat ../outs/URLDATASUSnok.txt | cut -d "|" -f "2" | cut -c47- >> mensagem.txt
  mail -s "[SciELO.ORG] Lista de link DATASUS quebrados" "francisco.lopes@bireme.org" < mensagem.txt
  rm mensagem.txt
fi

# ------------------------------------------------------------------------- #

#
## Done
#

echo === END ar1if.sh ===
date
 
exit



#
## etc
#

mx tabm -all now create=xtabm "proc='d5d6d7d8d9'"
mx null count=0 create=tabxm
mx xtabm jmax=3 "join=xa,8:2,9:3=mpu,|g=|v1/*v7*/"  "proc=if p(v8) then 'd32001' else 'd*' fi" -all now append=tabxm
echo "1020 tabxm"

mx tabu -all now create=xtabu "proc='d5d6d7d8d9'"
mx null count=0 create=tabxu
mx xtabu jmax=3 "join=xa,8:2,9:3=mpu,|u=|v1"        "proc=if p(v8) then 'd32001' else 'd*' fi" -all now append=tabxu
echo "1020 tabxu"

mx tabp -all now create=xtabp "proc='d5d6d7d8d9'"
mx null count=0 create=tabxp
mx xtabp jmax=3 "join=xa,8:2,9:3=mpu,|p=|v1"        "proc=if p(v8) then 'd32001' else 'd*' fi" -all now append=tabxp
echo "1020 tabxp"


exit
 
