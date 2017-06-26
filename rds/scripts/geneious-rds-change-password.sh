psql \
   --host=geneiousdb-oregon.czhnbtyqgkge.us-west-2.rds.amazonaws.com \
   --port=5432 \
   --username=<username> \
   --password \
   --dbname=geneious \
   -c "ALTER ROLE <username> PASSWORD '<password>'"
