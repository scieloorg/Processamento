#!/bin/bash
# ------------------------------------------------------------------------- #
# genAG.sh - Gera indice de areas geograficas do SciELO.BR
# ------------------------------------------------------------------------- #
#     entrada : 
#       saida : 
#     chamada : genAG.sh
#    corrente : /bases/scl.000/proc/mma
# comentarios : 
# observacoes : 
# ------------------------------------------------------------------------- #
#   Data    Responsavel          Comentario
# 20070824  AOTardelli           Edicao original
# 20110215  FJLopes              Revisao para execucao em plataforma G4
#

TPR="start"
. log

# Anota hora de inicio de operacao
HINIC=$(date '+%s')
HRINI=$(date '+%Y.%m.%d %H:%M:%S')
TREXE=$(basename $0)
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:INI:] Processa $0 $1 $2 $3 $4 $5"
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

unset LGDTC LGRAIZ LGPRD

# ------------------------------------------------------------------------- #
# [flx_MMA.txt : 01] Prepara tabelas
## step 0 - Prepara tabelas
#
# Montagem da tabela a partir de http://w3.datasus.gov.br/DATASUS/datasus.php?area=361A3B372C2D3690E6FG16HIJd3L1M0N&VAba=5&VInclude=../site/din_sist.php&VSis=1&VCoit=3690&VI=Município
# C:\mma\2007>mx CADUF "fst=1 0 v1/v2" fullinv=CADUF
# C:\mma\2007>mx CADMUN join=CADUF,102:2=v14 "proc='d*a1|'v1'|a2|'v7'|a3|'v6'|a4|'v102'|a5|'v3'|a6|'v102' - 'v6'|a7|'v2'|" bool=ATIVO -all now iso=tabmunic.iso
# C:\mma\2007>mx CADMUN join=CADUF,102:2=v14 "join=CADUF,202:2=v24.2" "proc='d6d7a6|'left(v6,instr(v6,' (')-1)'|a7|'left(v7,instr(v7,' (')-1)'|'" "proc='d*a1|'v1'|a2|'v7'|a3|'v6'|a4|'v102'|a5|'v3'|a6|'v102' - 'v6'|a7|'v2'|a17|'v202'|a24|'v24'|'" bool=TRANS -all now iso=tabmunic2.iso

## Tabela de Municipios BR
echo "Tabela de municipios BR == ANSI"
mx iso=tabs/tabmunic.iso  -all now create=tabmun gizmo=$TABS/g850ans tell=1000
mx iso=tabs/tabmunic2.iso -all now append=tabmun gizmo=$TABS/g850ans tell=1000

echo "Amostra de tabmun"
mx tabmun loop=1417 now
# 1020 tabmun
echo "1020 tabmun"

##  tira apostrofes e crases de Pau D'alho etc 
echo "Tira apostrofes e crases. Explo: Alta Floresta D'Oeste"
mx tabmun "proc='<9 0>'replace(v3,'\`',\`'\`)'</9>'" "proc=e1:=instr(v9,\`'\`),,if e1>0 then '<8 0>'replace(v9,\`'\`,'')'</8>','<8 0>'left(v9,e1-1)mid(v9,e1+1,1)' 'right(v9,size(v9)-e1)'</8>' fi" "proc='d9<8 0>'v9'</8>'" -all now uctab=ansi create=tabm

## Tabela de regioes brasileiras
echo "Tabela de regioes brasileiras"
mx seq=tabs/tabregiaoBR.seq create=tabs/tabregiaoBR -all now tell=1
mx tabs/tabregiaoBR "proc='Gsplit/clean=4=,'" "fst=1 0 (v4/)" fullinv=tabs/tabregiaoBR tell=5


## Tabela de Paises - match Brasil
#AE|EMIRADOS ÁRABES UNIDOS|UNITED ARAB EMIRATES|EMIRATOS ARABES UNIDOS

## Tabela de UF's BR - implementar BR no campo 1 - match AC, Brasil
#DF|Distrito Federal|Federal District|Districto Federal

## Tabela de AreasGeo - nome de areas/acidentes geograficos ainda nao traduzidos - match AC, Brasil
##|reserva
##|floresta
echo "Cria tabelas tabp; tabu; e tabg"
echo "tabp - Tabela de paises"
mx seq=tabs/tabpais.txt -all now create=tabp "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|" tell=10
echo "tabu - Tabela de unidade federativas"
mx seq=tabs/tabuf.txt   -all now create=tabu "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|" tell=5
echo "tabg - Tabela de entidades geograficas"
mx seq=tabs/tabgeo.txt  -all now create=tabg "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|" tell=1

# Exclusoes da tabela de municipios brasileiros
echo "Gera indixe das maiores cidades do mundo nao brasileiras. tablarg == maiores cidades do mundo"
# lind/mx ../tabs/tablarg create=tabs/tablarg "fst=1 0 if v20<>'BR' then v1 fi" fullinv=tabs/tablarg actab=$TABS/acans.tab uctab=ansi
mx tabs/tablarg "fst=1 0 if v20<>'BR' then v1 fi" fullinv=tabs/tablarg actab=$TABS/acans.tab uctab=ansi

## Tabela X = UF's BR + AreasGeo
## Tabela X = tabu    + tabg    
##
echo "tabx - Unidades Federativas e entidades geograficas == reservas e florestas"
echo " agrega UFs brasileiras"
mx tabu -all now create=tabx tell=5
echo " agrega entidades geograficas"
mx tabg -all now append=tabx tell=1

## Inverte codigo/valor(es)
#
echo "tabp - Indexa tabela de paises:  sigla e nome extenso em tres idiomas"
mx tabp   uctab=ansi "fst=1 0 v1/(v8/)"   fullinv=tabp
echo "tabu - Indexa tabela de ileiras: sigla e nome extenso em tres idiomas"
mx tabu   uctab=ansi "fst=1 0 v1/(v8/)"   fullinv=tabu
echo "tabx - Indexa tabela de UF e entidades: nome extenso"
mx tabx   uctab=ansi "fst=1 0    (v8/)"   fullinv=tabx

# ------------------------------------------------------------------------- #
## Cria tabloc
#
# TABLOC eh dividida em faixas, sendo:
#     1 a   999 Paises
#		campo 11^* contem o nome do pais em tres idiomas
#  1001 a  9999 Unidades Federativas
#		campo 12^* contem o nome da UF ^u a sigla e ^x o Chico nao sabe, mas esta sempre com 0
# 10001 a 99999 Municipios
#		campo 13^* contem o nome do municipio ^u a sigla do estado ^v o nome do estado e ^x o Chico nao sabe, mas esta sempre com 0
# Campo 10 sempre contem a indicacao de base e MFN de origem do registro

# v11   - pais

# v12^u - uf
# v12^x - pais

# v13^u - mun
# v13^v - uf
# v13^x - 

echo "Cria tabloc ==  contendo paises unidades federativas e municipios"
echo "  agrega paises == MFNs de 1 a 999"
mx tabp uctab=ansi "proc=(if p(v8) then '<11 0>'v8'</11>'                                                                fi)" -all now create=tabloc "proc=if p(v11) then 'a10/tabp^m'mfn(1)'/' fi"
echo "  agrega UFs == MFNs de 1001 a 9999"
mx tabu uctab=ansi "proc=(if p(v8) then '<12 0>'v8'^u'v1[1]                                '^x'f(l->tabp(v8),1,0)'</12>' fi)" -all now   copy=tabloc "proc=if p(v12) then 'a10/tabu^m'mfn(1)'/' fi" "proc='='f( 1000+mfn,1,0)" 
echo "  agrega municipios == MFNs de 10001 em diante"
mx tabm uctab=ansi "proc=(if p(v8) then '<13 0>'v8'^u'v4[1]'^v'ref->tabu(l->tabu(v4[1]),v2)'^x'f(l->tabx(v8),1,0)'</13>' fi)" -all now   copy=tabloc "proc=if p(v13) then 'a10/tabm^m'mfn(1)'/' fi" "proc='='f(10000+mfn,1,0)" 

# 1020 tabloc
echo "1020 tabloc"

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

echo "Cria a tabela de denominacao de areas == regiao, pais, estado, cidade"
mx seq=tabs/tabarea.txt -all now create=taba "proc='d8',|<8 0>|v2|</8>|,|<8 0>|v3|</8>|,|<8 0>|v4|</8>|"
echo "Inverte tabloc agregando as qualificacoes das entidades == estado de, ou municipalities e etc"
mx tabloc uctab=ansi "fst=1 0 @tabs/ar12fst.pft" fullinv=tabloc tell=3000
mx taba   uctab=ansi "fst=1 0 v2"                fullinv=taba


## Gizmo Ansi to Uppercase + remove comma 
#
echo "Cria gizmo para converter em UPPER CASE eliminando virgula"
mx iso=tabs/gansuc.iso -all now create=gansuc+comma
mx null count=1 "proc='a1/,/'" -all now append=gansuc+comma


#
## step 1 - Extrai dado em ingles (titulo se e1=0, ou titulo, resumo e keywords se e1=1)
#
echo "Extrai dado em ingles. Titulo ou Titulo + resumo + keywords"
mx null count=0 create=xart2 tell=1000
#mx cipar=artigo.cip artigo bool=TP=H "proc=if p(v32701) then 'R'v32701^*','v32701^m fi" uctab=ansi "proc=e1:=1,@tabs/ar1aif.pft" -all now append=xart2 tell=1000
# [CHICO] mx ../iso/artigos uctab=ansi "proc=e1:=1,@tabs/ar1aif.pft" -all now append=xart2 tell=1000
# Temos de utilizar um proc de leitura adaptado ao caminho relativo em que estamos, por isso Art_mma.prc
echo "mx ../../bases/artigo/artigo \"proc=@../prc/Art_mma.prc\" tp=h uctab=ansi \"proc=e1:=1,@tabs/ar1aif.pft\" -all now append=xart2 tell=1000"
      mx ../../bases/artigo/artigo "proc=@../prc/Art_mma.prc" tp=h uctab=ansi "proc=e1:=1,@tabs/ar1aif.pft" -all now append=xart2 tell=1000

echo "Marca areas geograficas com Gsplit=2=6word/if=tabloc"
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
# mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now create=xar2 tell=50000
## Processamento em duas partes
# mx null count=1 create=xaa2
# mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now   copy=xaa2 tell=1001 to=50000
# mx xart2 uctab=ansi proc=@tabs/ar1bif.pft proc=@tabs/ar1d.pft proc=@tabs/ar1e.pft proc=@tabs/ar1f.pft proc=@tabs/ar1g.pft proc=@tabs/ar1h.pft -all now   copy=xaa2 tell=1002 from=50001 to=57175

echo "Cria base xar2"
mx xart2 uctab=ansi "proc='d2d12d83d85<2 0>'v12'. 'v83'. 'v85'</2>'" "proc='Gmark/2/AREA=tabloc'" "proc='Gmarx/2/AREA =3:^k&key^m&mfn'" "proc='d2d3'(if p(v3) then '<2 0>'v3^k'^m'v3^m'</2>' fi)"  proc=@tabs/ar1d.pft "proc='d2d3'(if p(v2) then '<3 0>'v2'</3>',if iocc>33 then break fi fi)" proc=@tabs/ar1f.pft proc=@tabs/ar1g2.pft  proc=@tabs/ar1h.pft -all now create=xar2 tell=1000 

# 1020 xar2
echo "1020 xar2"


#
## step 3 - Lista resultado
#
echo "Lista resultado"
mxtb xar2 create=x5 "60:(v5^*/)" class=10000 tell=5000
msrt x5 10 v998
  mx x5 "pft=f(val(v999),8,0),x4,v1/" now count=20

echo "Inverte xar2"
mx xar2 actab=$TABS/acans.tab uctab=ansi "fst=1 0 '.artigos'/,(if p(v5) then v5^*/'.artigos com area geografica'/,if v5^t='tabm' then '.area=municipio'/'m='v5^*/'g='v5^g/ else if v5^t='tabu' then '.area=uf'/'u='v5^*/ else if v5^t='tabp' then '.area=pais'/'p='v5^*/ fi fi fi fi)" fullinv=xar2 tell=10000

# Stdout top results
echo "Exibe resultados"
mx dict=xar2 k1=m= k2=m= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=u= k2=u= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=p= k2=p= "pft=if val(v1^t)>10 then f(val(v1^t),8,0),x4,v1^*/ fi" now
mx dict=xar2 k1=. k2=.                        "pft=f(val(v1^t),8,0),x4,v1^*/"    now


## Resultado completo 
# extraido por formato (tabs/ar1.pft)
# carregado em mf
# invertido por PID; nomes; m=mun u=uf p=pais; g=geo; tipo access point t=m ou t=u ou t=p
#
echo "Gera base e invertido XA"
# [CHICO PROP] mx xar2 uctab=ansi actab=$TABS/acans.tab pft=@tabs/ar1.pft lw=32000 now tell=1000000>xa.txt
mx xar2 uctab=ansi pft=@tabs/ar1.pft lw=32000 now tell=1000000>xa.txt
mx seq=xa.txt -all now create=xa 
mx xa uctab=ansi "fst=1 0 'pid='v2/,v4/v5/v6/v7/v8/v9/v10/v11/v12/,|m=|v4/,|u=|v5/,|p=|v6/,|g=|v8/,'t='v10,v11,v12" fullinv=xa tell=5000
## 1020 xa
echo "## 1020 xa"

# Stdout top results
echo "Exibe resultado"
mx dict=xa k1=t= k2=t= "pft=f(val(v1^t),8,0),x4,v1^*/" now

# Sequential output - transferir a MMA (a/c PHAS): xa?.txt
echo "Gera lista de municipios"
mx xa btell=0 t=m -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xam.txt
echo "Gera lista de unidades federativas"
mx xa btell=0 t=u -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xau.txt
echo "Gera lista de paises"
mx xa btell=0 t=p -all now lw=32000 "pft=v2'|'v3'|'v4'|'v5'|'v6'|'v7'|'v8'|'v9'|'v10,v11,v12/" >xap.txt

echo "Gera base de municipios"
mx seq=xam.txt -all now create=xam
## 1020 xam
# Municipios brasileiros
[ -f "xamBR.xrf" ] && rm -f xamBR.*

# Municipios brasileiros sem duvidas grandes
echo "Gera base de municipios brasileiros"
mx xam actab=$TABS/acans.tab uctab=ansi "proc=if l(['tabs/tablarg']s(mpu,v3,mpl))>0 then 'd*' fi" append=xamBR -all now
## 1020 xamBR
echo "Gera base de estados brasileiros"
mx seq=xau.txt -all now create=xau
## 1020 xau
echo "Gera base de paises"
mx seq=xap.txt -all now create=xap
## 1020 xap


## Controle - transferir a serverofi.bireme.br: resumo xax.txt + xar2.* para browse da base artigo*
#
#  'ARTIGOS|'                    f(npost->xar2('.ARTIGOS'),1,0)                                                  /
#  'ARTIGOS COM AREA GEOGRAFICA|'f(npost->xar2('.ARTIGOS COM AREA GEOGRAFICA'),1,0)                              /
#  'ARTIGOS COM MUNICIPIO|'      f(npost->xar2('.AREA=MUNICIPIO'),1,0)             '|'ref->xam(1,f(maxmfn-1,1,0))/
#  'ARTIGOS COM UF|'             f(npost->xar2('.AREA=UF'),1,0)                    '|'ref->xau(1,f(maxmfn-1,1,0))/
#  'ARTIGOS COM PAIS|'           f(npost->xar2('.AREA=PAIS'),1,0)                  '|'ref->xap(1,f(maxmfn-1,1,0))/

echo "Resumo de dados obtidos"
mx null count=1 pft=@tabs/ar1x.pft lw=999 now > xax.txt
cat xax.txt

# ------------------------------------------------------------------------- #
# Inverte por areas geograficas

echo "[INI] Inversao por areas geograficas para SciELO.ORG"
echo "(if v5^t='tabm' then |AM_|v5^*/ fi)"  > tabs/ageo.pft
echo "(if v5^t='tabu' then |AS_|v5^*/ fi)" >> tabs/ageo.pft
echo "(if v5^t='tabp' then |AC_|v5^*/ fi)" >> tabs/ageo.pft

# Inverte por Pais (AC_), Estado (AS_), e Cidade (AM_)
[ -f "arGeo.iy0" ] && rm -f arGeo.iy0
 mx xar2 "fst=82 0 @tabs/ageo.pft" actab=$TABS/acans.tab uctab=$TABS/ucans.tab fullinv=arGeo tell=5000
 mkiy0 arGeo
 rm -f arGeo.cnt arGeo.n0? arGeo.ly? arGeo.iyp


# Inverte por municipio
# mx xar2 "fst=444 0 (if v5^t='tabm' then v5^*/ fi)" fullinv=wmun tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab
# Inverte por unidade federativa
# mx xar2 "fst=444 0 (if v5^t='tabu' then v5^*/ fi)" fullinv=wuni tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab
# Inverte por pais
# mx xar2 "fst=444 0 (if v5^t='tabp' then v5^*/ fi)" fullinv=wpai tell=2000 actab=$TABS/acans.tab uctab=$TABS/ucans.tab

echo "[FIM] Inversao por areas geograficas para SciELO.ORG"
echo "[INI] Gera dados para servico web"

 echo "Gera invertido de municipios brasileiros"
 mx xamBR "fst=1 0 v1" fullinv=xamBR
 mx dict=xamBR,8801,8802 "join=xamBR=(|mfn=|v8802^m/)" "proc='d32001'" -all now create=x
# #mx x "join=tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc='d32001'" "proc=(if p(v6) then if v106[1]:s('~'v6'~') then else proc('d106a106|'v106[1],'~'v6'~','|') fi fi)" "proc='Gsplit/clean=106=~'" "proc=(if p(v12) then if v112[1]:s('~'v12'~') then else proc('d112a112|'v112[1],'~'v12'~','|') fi fi)" "proc='Gsplit/clean=112=~'" -all now create=xx
# mx x "join=tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)" "proc='s20'" "proc=|<200 0>|v20|</200>|" "proc='Gtabs/gcharurl,200'" lw=0 pft=@p1.pft from=1511

 echo "Gera base de areas geograficas"
 mx x "join=tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)" "proc='s20'" "proc=|<200 0>|v20|</200>|" "proc='G$TABS/gansna,200'" "proc='Gtabs/gcharurl,200'" "proc='d*a880|'v1[1]'|<1 0>',@areasgeo1_SCL.pft,'</1>'" create=areasgeoBR -all now

echo "Gera invertido de areas geograficas"
 [ -f "areasgeoBR.iy0" ] && rm -f areasgeoBR.iy0
# mx areasgeoBR "fst=1 0 v880^c,v880^*/,v880^*/,v880^c" fullinv=areasgeoBR
  mx areasgeoBR "fst=1 0 'scl',v880^*/,v880^*/,'scl'"   fullinv=areasgeoBR
 mkiy0 areasgeoBR
 rm -f areasgeoBR.cnt areasgeoBR.ly? areasgeoBR.n0? areasgeoBR.iyp


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
# mx x "join=tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)"  "fst=1 1000 if l->xpids(v8801^*'^c'v8801^c)>0 then '/'f(l->xpids(v8801^*'^c'v8801^c),1,0)'/',(if p(v20) then 'Pais 'v20^p/,'Regiao 'v20^r/,'UF 'v20^u/,v20^m/ fi) fi" uctab=ansi actab=$TABS/acans.tab master=../iso/art.scl/artigo fullinv=artscl_AG tell=1000
# rm xpids.*
# mkiy0 artscl_AG 
# rm artscl_AG.cnt artscl_AG.ly? artscl_AG.n0? artscl_AG.iyp
# ------------------------------------------------------------------------- #
## Versao SciELO.BR
## 
 echo "Gera invertido de artigo por PID"
 mx ../../bases/artigo/artigo "proc=@../prc/Art_mma.prc" btell=0 TP=H "fst=3 0 v880/,v880,'^cscl'/" fullinv=xpids tell=5000
 
 echo "Inverte apontando para MFNs da artigo"
 [ -f "artscl_AG.iy0" ] && rm -f artscl_AG.iy0
 mx x "join=tabs/tabregiaoBR,11:1,12:2=(v4/)" "proc=(if p(v1) then 'a20|^p'v8'^0'v5,'^r'v12'^1'v11,'^u'v6'^2'v4,'^m'v3'^3'v7'|' fi)" "fst=1 1000 if l->xpids(v8801^*)>0 then '/'f(l->xpids(v8801^*),1,0)'/',(if p(v20) then 'Pais 'v20^p/,'Regiao 'v20^r/,'UF 'v20^u/,v20^m/ fi) fi" actab=$TABS/acans.tab uctab=ansi "master=../../bases/artigo/artigo" "fullinv=artscl_AG" "tell=1000"
 mkiy0 artscl_AG
 rm -f artscl_AG.cnt artscl_AG.ly? artscl_AG.n0? artscl_AG.iyp
 rm xpids.*

# Transfere resultados de areas geograficas
# Para trigramas
# Para Homologacao
# Para servidor de teste de desenvolvimento
# Prover transferencia para ftp Chile, Cuba, ...

# ------------------------------------------------------------------------- #
# Depois pega carona num FTP para homologacao
cp artscl_AG.iy0 ../../bases/iah/library

echo "[FIM] Gera dados para servico web"
# ------------------------------------------------------------------------- #
unset CIPAR

# ------------------------------------------------------------------------- #
echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:FIM:] Processa $0 $1 $2 $3 $4 $5"

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

echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]" >> $LGRAIZ/$LGPRD/outs/$LGPRC.tim
unset HINIC
unset HFINI
unset TPROC

TPR="end"
. log

echo "[TIME-STAMP] $(date '+%Y.%m.%d %H:%M:%S') [:FIM:] Processa $0 $1 $2 $3 $4 $5"
 
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

