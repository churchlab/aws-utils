pg_dump \
    -Fc -v \
    --host=geneiousdb-oregon.czhnbtyqgkge.us-west-2.rds.amazonaws.com \
    --port=5432 \
    --username=lakhim \
    --password \
    --dbname=geneious \
    > geneiousdb.dump
