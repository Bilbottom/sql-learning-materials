"""
Pull the resources from the web and store them locally.
"""

from __future__ import annotations

import enum
import gzip
import logging
import pathlib
import shutil
import sqlite3
import tomllib
import urllib.request
from collections.abc import Callable

from src import ROOT, SRC

logging.getLogger().setLevel(logging.INFO)


def _unzip_file(file: pathlib.Path) -> None:
    """
    Unzip a file.

    Stolen from:

    - https://stackoverflow.com/a/44712152/8213085

    :param file: The path to the file to unzip. It is assumed that the file
        has a ".gz" extension which will be removed after unzipping.
    """
    logging.info(f"Unzipping '{file}'...")
    with gzip.open(file, "rb") as f_zipped:
        with open(file.with_suffix(""), "wb") as f_unzipped:
            shutil.copyfileobj(f_zipped, f_unzipped)

    file.unlink()


def _create_database__sqlite(
    database_file: pathlib.Path,
    sql_file: pathlib.Path,
) -> None:
    """
    Create a SQLite database.

    :param database_file: The path to the database file.
    :param sql_file: The path to the SQL file to execute.
    """
    logging.info(f"Creating SQLite database '{database_file}'...")
    sqlite3.connect(database_file).executescript(sql_file.read_text())


def _create_database__duckdb(
    database_file: pathlib.Path,
    sql_file: pathlib.Path,
) -> None:
    """
    Create a DuckDB database.

    :param database_file: The path to the database file.
    :param sql_file: The path to the SQL file to execute.
    """
    import duckdb

    database, schema = database_file.name.split(":")

    logging.info(f"Using DuckDB database '{database}'...")
    conn = duckdb.connect(str(database_file.parent / database))

    logging.info(f"Creating DuckDB schema '{schema}'...")
    conn.execute(f"drop schema if exists {schema} cascade")
    conn.execute(f"create schema {schema}")
    conn.execute(f"use {schema}; {sql_file.read_text()}")


class DatabaseType(enum.StrEnum):
    DUCKDB = "duckdb"
    POSTGRES = "postgres"
    MSSQL = "mssql"
    SQLITE = "sqlite"

    def create_database(
        self,
        database_file: pathlib.Path,
        destination: pathlib.Path,
    ) -> None:
        """
        Some databases are just single files, so using a Docker container is
        overkill. Instead, we'll just create the database files locally.

        :param database_file: The path to the database file.
        :param destination: The path to the SQL file to execute.

        :raises KeyError: If the database type cannot be instantiated as a local
            file.
        """
        create_db: dict[DatabaseType, Callable] = {
            DatabaseType.SQLITE: _create_database__sqlite,
            DatabaseType.DUCKDB: _create_database__duckdb,
        }
        create_db[self](database_file, destination)


class Resource:
    """
    A resource to be downloaded.
    """

    type: DatabaseType
    name: str
    url: str
    destination: pathlib.Path
    database_file: pathlib.Path | None
    skip: bool

    def __init__(
        self,
        type_: DatabaseType,
        name: str,
        url: str,
        destination: pathlib.Path,
        database_file: pathlib.Path | None,
        skip: bool | False,
    ) -> None:
        self.type = type_
        self.name = name
        self.url = url
        self.destination = destination
        self.database_file = database_file
        self.skip = skip

    def __str__(self):
        return (
            f"Resource("
            f"type_='{self.type}', "
            f"name='{self.name}', "
            f"url='{self.url}', "
            f"destination='{self.destination}', "
            f"database='{self.database_file}', "
            f"skip={self.skip}"
            f")"
        )

    def __repr__(self):
        return str(self)

    @classmethod
    def from_dict(
        cls,
        type_: DatabaseType,
        resource: tuple[str, dict[str, str]],
        destination_root: pathlib.Path,
    ) -> Resource:
        name, details = resource
        return cls(
            type_=type_,
            name=name,
            url=details["url"],
            destination=destination_root / details["destination"],
            database_file=(
                destination_root / details["database"]
                if "database" in details
                else None
            ),
            skip=details.get("skip"),
        )

    def get_resource(self) -> None:
        """
        Download the resource.
        """
        logging.info(f"Downloading from '{self.url}'...")
        urllib.request.urlretrieve(self.url, self.destination)
        if self.destination.suffix == ".gz":
            _unzip_file(self.destination)

    def create_database(self) -> None:
        """
        Some databases are just single files, so using a Docker container is
        overkill. Instead, we'll just create the database files locally.
        """
        if self.database_file:
            logging.info(f"Creating database from '{self.destination}'...")
            self.type.create_database(self.database_file, self.destination)


def _open_resource_config(
    filename: pathlib.Path,
    destination_root: pathlib.Path = ROOT,
) -> list[Resource]:
    """
    Open the resource file and return a list of the resource objects.

    :param filename: The path to the resource file.

    :return: A list of the resource objects.
    """
    config = tomllib.loads(filename.read_text())

    return [
        Resource.from_dict(DatabaseType(type_), resource, destination_root)
        for type_, resources in config.items()
        for resource in resources.items()
    ]


def main() -> None:
    """
    Pull the resources from the web and store them locally.
    """
    resources = _open_resource_config(SRC / "resources/resources.toml")
    for resource in resources:
        if resource.skip:
            logging.info(f"Skipping '{resource.type}.{resource.name}'...")
            continue
        resource.get_resource()
        resource.create_database()


if __name__ == "__main__":
    main()
