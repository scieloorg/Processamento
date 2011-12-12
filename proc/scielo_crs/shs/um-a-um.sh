echo  "./crossref_run.sh $(./crossref_Consulta_ISSN_Title.sh $1)"
       ./crossref_run.sh $(./crossref_Consulta_ISSN_Title.sh $1)
sleep 1
if [ -f crossref_sent_$(date '+%Y%m%d').log  ]; then
echo  "mv crossref_sent_$(date '+%Y%m%d').log crossref_sent_$(date '+%Y%m%d')_$1.log"
       mv crossref_sent_$(date '+%Y%m%d').log crossref_sent_$(date '+%Y%m%d')_$1.log
fi
if [ -f validationErrors_$(date '+%Y%m%d').log  ]; then
echo  "mv validationErrors_$(date '+%Y%m%d').log validationErrors_$(date '+%Y%m%d')_$1.log"
       mv validationErrors_$(date '+%Y%m%d').log validationErrors_$(date '+%Y%m%d')_$1.log
fi
