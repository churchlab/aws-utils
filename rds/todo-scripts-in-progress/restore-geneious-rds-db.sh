pg_restore \
    -v \
    --host=geneious-db.c1tlo6odopqe.us-east-1.rds.amazonaws.com \
    --port=5432 \
    --username=lakhim \
    --password \
    --dbname=geneious \
    geneiousdb.dump
