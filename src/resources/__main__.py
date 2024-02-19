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

    logging.info(f"Creating DuckDB database '{database_file}'...")
    duckdb.connect(str(database_file)).execute(sql_file.read_text())


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
    url: str
    destination: pathlib.Path
    database_file: pathlib.Path | None

    def __init__(
        self,
        type_: DatabaseType,
        url: str,
        destination: pathlib.Path,
        database_file: pathlib.Path | None,
    ) -> None:
        self.type = type_
        self.url = url
        self.destination = destination
        self.database_file = database_file

    def __str__(self):
        return (
            f"Resource("
            f"type_='{self.type}', "
            f"url='{self.url}', "
            f"destination='{self.destination}', "
            f"database='{self.database_file}'"
            f")"
        )

    def __repr__(self):
        return str(self)

    @classmethod
    def from_dict(
        cls,
        type_: DatabaseType,
        details: dict[str, str],
        destination_root: pathlib.Path,
    ) -> Resource:
        return cls(
            type_=type_,
            url=details["url"],
            destination=destination_root / details["destination"],
            database_file=(
                destination_root / details["database"]
                if "database" in details
                else None
            ),
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
        Resource.from_dict(DatabaseType(type_), details, destination_root)
        for type_, resources in config.items()
        for details in resources.values()
    ]


def main() -> None:
    """
    Pull the resources from the web and store them locally.
    """
    resources = _open_resource_config(SRC / "resources/resources.toml")
    for resource in resources:
        resource.get_resource()
        resource.create_database()


if __name__ == "__main__":
    main()
