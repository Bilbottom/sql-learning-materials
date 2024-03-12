"""
Time the queries in the queries directory.
"""

import sqlite3

import db_query_profiler
import pyodbc

from src import SRC

Connection = db_query_profiler.query_timer.DatabaseConnection


def sqlite_connector() -> Connection:
    return sqlite3.connect(":memory:")  # type: ignore


def mssql_connector() -> Connection:
    # TODO: Grab from `src/metabase/databases.toml`
    connection = pyodbc.connect(
        "Driver={SQL Server};"
        "Server=localhost;"
        "Database=AdventureWorks2022;"
        "UID=SA;"
        "PWD=Test@12345;"
    )

    return connection.cursor()  # type: ignore


def postgres_connector() -> Connection:
    pass


def main() -> None:
    """
    Time the queries in the queries directory.
    """
    db_conn = (
        # sqlite_connector()
        mssql_connector()
        # postgres_connector()
    )
    db_query_profiler.time_queries(
        conn=db_conn,
        repeat=1_000,
        directory=SRC / "profiler/queries",
    )


if __name__ == "__main__":
    main()
