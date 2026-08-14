"""
Time the queries in the queries directory.
"""

import pathlib
import sqlite3

import db_query_profiler
import duckdb
import psycopg2
import pyodbc

from src import SRC

HERE = pathlib.Path(__file__).resolve().parent
DB_PATH = SRC / "resources/data"

type Connection = db_query_profiler.query_timer.DatabaseConnection


def sqlite_connector() -> Connection:
    return sqlite3.connect(DB_PATH / "sqlite/loan.db")  # type: ignore


def duckdb_connector() -> Connection:
    return duckdb.connect(database=str(DB_PATH / "duckdb/duckdb.db"))  # type: ignore


def mssql_connector() -> Connection:
    # TODO: Grab from `src/databases.toml`
    connection = pyodbc.connect(
        "Driver={SQL Server};"
        "Server=localhost;"
        "Database=AdventureWorks2022;"
        "UID=SA;"
        "PWD=Test@12345;"
    )

    return connection.cursor()  # type: ignore


def postgres_connector() -> Connection:
    # TODO: Grab from `src/databases.toml`
    connection = psycopg2.connect(
        "dbname=postgres user=postgres password=Test@12345"
    )
    return connection.cursor()


def main() -> None:
    """
    Time the queries in the queries directory.
    """
    db_conn = {
        "sqlite": sqlite_connector,
        "duckdb": duckdb_connector,
        "mssql": mssql_connector,
        "postgres": postgres_connector,
    }["duckdb"]

    setup_sql = (HERE / "setup.sql").read_text(encoding="utf-8")
    db_conn().execute(setup_sql)

    db_query_profiler.time_queries(
        conn=db_conn(),
        repeat=1_000,
        directory=SRC / "profiler/queries",
    )


if __name__ == "__main__":
    main()
