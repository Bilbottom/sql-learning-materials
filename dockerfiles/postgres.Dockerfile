FROM postgres

###
# This expects some files to exist at the locations given below. The
# files can be downloaded from:
#
#   - https://github.com/jOOQ/sakila/tree/main/postgres-sakila-db
#
# The exact versions used during the development of this project are:
#
#   - https://raw.githubusercontent.com/jOOQ/sakila/38c2e4ef53cf7ef2eec873d42c5a1e2c7afa0231/postgres-sakila-db/postgres-sakila-schema.sql
#   - https://raw.githubusercontent.com/jOOQ/sakila/38c2e4ef53cf7ef2eec873d42c5a1e2c7afa0231/postgres-sakila-db/postgres-sakila-insert-data-using-copy.sql
#
# All credit to jOOQ (and their sources) for the sample database.
###
COPY src/resources/data/postgres/postgres-sakila-schema.sql /docker-entrypoint-initdb.d/1__postgres-sakila-schema.sql
COPY src/resources/data/postgres/postgres-sakila-insert-data-using-copy.sql /docker-entrypoint-initdb.d/2__postgres-sakila-insert.sql
