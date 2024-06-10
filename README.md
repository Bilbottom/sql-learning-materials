<div align="center">

[![Poetry](https://img.shields.io/endpoint?url=https://python-poetry.org/badge/v0.json)](https://python-poetry.org/)
[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Docker](https://img.shields.io/badge/Docker-24.0.5-blue.svg)](https://www.docker.com/)
[![GitHub last commit](https://img.shields.io/github/last-commit/Bilbottom/sql-learning-materials)](https://shields.io/badges/git-hub-last-commit-by-committer)

[![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-teal.svg)](https://www.microsoft.com/en-gb/sql-server/sql-server-downloads)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16.2-teal.svg)](https://www.postgresql.org/download/)
[![SQLite](https://img.shields.io/badge/SQLite-3.45-teal.svg)](https://www.sqlite.org/index.html)
[![DuckDB](https://img.shields.io/badge/DuckDB-1.0-teal.svg)](https://duckdb.org/)
[![Metabase](https://img.shields.io/badge/Metabase-0.47-teal.svg)](https://www.metabase.com/)

</div>

---

# SQL Learning Materials

SQL scripts that demonstrate various features and concepts.

This project contains a bunch of SQL learning materials aimed at different levels of experience and covering a variety of topics. It focuses on just writing `SELECT` statements so there will be very few resources for anything else.

Jump into [https://bilbottom.github.io/sql-learning-materials/](https://bilbottom.github.io/sql-learning-materials/) to see the summary of what's covered in this project, and continue below for instructions on how to set up the databases.

## Acknowledgements

The data used in this project is from a couple of sources.

The SQL Server instance will load the ubiquitous _AdventureWorks_ databases (the transactional one and the analytical one), which is available from various Microsoft pages:

- https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure
- https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks

The PostgreSQL instance will load the similarly ubiquitous _Sakila_ database, which is available from the following GitHub repo:

- https://github.com/jOOQ/sakila/

All credit for the data goes to the respective owners, and these sources should be consulted for any documentation you need around the data.

The docs are built using [MkDocs](https://www.mkdocs.org/) and the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme, with several plugins to make the experience more interactive. I cannot express the love I have for the maintainers of these tools!

## Pre-requisites

This project uses Poetry to manage the Python dependencies and Docker to spin up the databases.

To install these, follow the instructions on their websites:

- https://python-poetry.org/docs/#installation
- https://www.python.org/downloads/
- https://docs.docker.com/get-docker/

## Quick start

After installing the pre-requisites and cloning this repo, just run the `resources` package to download the files needed to feed into the SQL Server and PostgreSQL databases before running Docker's `compose` command.

```bash
poetry install --sync  # --with dev,test,docs
python -m resources
docker compose up --detach
mkdocs build
mkdocs serve
docker compose down --volumes  # When you're finished
```

This will take a little while to run since there's a fair bit of data to chunk through.

You can connect to the databases using any of your favourite SQL clients.

The credentials for the databases are not sensitive and are defined in the `docker-compose.yml` file. For reference, the credentials are:

| Database   | Username | Password   | Host      | Port |
| ---------- | -------- | ---------- | --------- | ---- |
| SQL Server | SA       | Test@12345 | localhost | 1433 |
| PostgreSQL | postgres | Test@12345 | localhost | 5432 |

The SQLite and DuckDB databases are just files, so using Docker for these is overkill -- when you run `python -m resources`, the files for these databases will be created in your file system. The file locations are defined in the `resources.toml` config file (you can override them there if you want) and are:

| Database | File location                       |
| -------- | ----------------------------------- |
| SQLite   | `src/resources/data/sqlite/loan.db` |
| DuckDB   | `src/resources/data/duckdb/loan.db` |

The Metabase instance will be launched on [`localhost:3000`](http://localhost:3000) and you will have to configure your own login details.

## On an M1 mac...

...you will have to make sure that you have enabled the virtualisation framework and Rosetta for amd64 support, see the following GitHub issue and comment:

- https://github.com/microsoft/mssql-docker/issues/668#issuecomment-1436802153
