#------------------------------------------------------------------------#
# confout.sh
# 
# Busca por palavras que possam identificar erro registrado no arquivo
# de out de processamento
# 
# Sintaxe: confout.sh <file_out>
#   onde <file_out> -> arquivo de out
#
# Data criacao: 24/06/2009
# Fabio Luis de Brito
#-----------------------------------------------------------------------#

TPR="start"
. log

# Verifica a passagem do parametro
if [ "$#" -ne 1 ]
then
   TPR="fatal"
   MSG="use: confout.sh <file_out>"
   . log
fi

DIRETORIO=`pwd`
ARQUIVO=$DIRETORIO/$1


#------------------------------------------------------------------------#
# Busca de palavras especificas
#------------------------------------------------------------------------#
grep -i -n "fatal: " $1  > tmp
grep -i -n "\bERRO[S]\b" $1  >> tmp
grep -i -n segmentation $1  >> tmp
grep -n "o such" $1 >> tmp
grep -i -n "\bdenied\b" $1 >> tmp
grep -i -n "Connection refused" $1 >> tmp

	case $(wc -c tmp) in
		0*) 
			clear
			echo "+-----------------------------------------------------------+"
			echo "|                                                           |"
			echo "| Processamento OK!!!                                       |"
			echo "|                                                           |"			
			echo "| Nao foram encontrados erros conhecidos no arquivo abaixo: |"
			echo "|                                                           |"
			echo "+-----------------------------------------------------------+"
			echo "$ARQUIVO"
			echo
			echo
			rm tmp;;
		*)  
			clear
			echo "+-----------------------------------------------------------+"
			echo "| ATENCAO! - Erros conhecidos foram encontrados no arquivo:"
			echo "| $ARQUIVO"
			echo "+-----------------------------------------------------------+"
			echo "Linha : erro"
			less tmp
			echo "+-----------------------------------------------------------+"
			echo
			echo
			rm tmp;;
	esac
