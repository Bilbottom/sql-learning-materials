FROM mcr.microsoft.com/mssql/server:2022-latest
ENV SA_PASSWORD="Test@12345"

###
# This expects some files to exist at the locations given below. The
# files can be downloaded from:
#
#   - https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure
#
# All credit to Microsoft for the sample databases.
###
COPY src/resources/data/mssql/AdventureWorks2022.bak /.
COPY src/resources/data/mssql/AdventureWorksDW2022.bak /.

RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 10 \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Test@12345" \
      -Q "RESTORE DATABASE AdventureWorks2022 FROM DISK='/AdventureWorks2022.bak' WITH \
            MOVE 'AdventureWorks2022'     TO '/var/opt/mssql/data/AdventureWorks2022.mdf', \
            MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf'" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Test@12345" \
      -Q "RESTORE DATABASE AdventureWorksDW2022 FROM DISK='/AdventureWorksDW2022.bak' WITH \
            MOVE 'AdventureWorksDW2022' TO '/var/opt/mssql/data/AdventureWorksDW2022.mdf', \
            MOVE 'AdventureWorksDW2022_log' TO '/var/opt/mssql/data/AdventureWorksDW2022_log.ldf'" \
