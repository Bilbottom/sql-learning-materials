"""
Unit tests for the ``src/resources`` package.
"""
import gzip
import pathlib

import pytest

import src.resources.__main__ as resources


@pytest.fixture
def zipped_file(tmp_path: pathlib.Path) -> pathlib.Path:
    """
    Create a zipped file for testing.
    """
    file = tmp_path / "test.txt.gz"
    with gzip.open(file, "wb") as f:
        f.write(b"Hello, world!")

    return file


@pytest.fixture
def resource() -> resources.Resource:
    """
    Create a resource object for testing.
    """
    return resources.Resource(
        type_=resources.DatabaseType.SQLITE,
        url="https://example.com",
        destination=pathlib.Path("test.sql"),
        database_file=pathlib.Path("test.db"),
    )


def test__unzip_file(zipped_file: pathlib.Path):
    """
    Test the ``_unzip_file`` function.
    """
    resources._unzip_file(zipped_file)

    assert zipped_file.with_suffix("").exists()


def test__resource():
    """
    Test the instantiation of the ``Resource`` class.
    """
    resource = resources.Resource(
        type_=resources.DatabaseType.SQLITE,
        url="https://example.com",
        destination=pathlib.Path("test.sql"),
        database_file=None,
    )

    assert resource.type == "sqlite"
    assert resource.url == "https://example.com"
    assert resource.destination == pathlib.Path("test.sql")
    assert resource.database_file is None
    assert str(resource) == (
        "Resource("
        "type_='sqlite', "
        "url='https://example.com', "
        "destination='test.sql', "
        "database='None'"
        ")"
    )
    assert repr(resource) == str(resource)


def test__resource__from_dict(tmp_path: pathlib.Path):
    """
    Test the ``from_dict`` method of the ``Resource`` class.
    """
    resource = resources.Resource.from_dict(
        type_=resources.DatabaseType.SQLITE,
        details={
            "url": "https://example.com",
            "destination": "test.sql",
        },
        destination_root=tmp_path,
    )

    assert resource.type == "sqlite"
    assert resource.url == "https://example.com"
    assert resource.destination == tmp_path / "test.sql"
    assert resource.database_file is None


@pytest.mark.skip(reason="This test downloads a real file, need to mock this.")
def test__resource__get_resource(resource: resources.Resource):
    """
    Test the ``get_resource`` method of the ``Resource`` class.
    """
    resource.get_resource()

    assert resource.destination.exists()


def test__open_resource_config(tmp_path: pathlib.Path):
    """
    Test the ``_open_resource_config`` function.
    """
    config_file = tmp_path / "test.toml"
    config_file.write_text(
        """
        [sqlite.test-config]
        url = "https://example.com"
        destination = "test.sql"
        """
    )
    resources_ = resources._open_resource_config(config_file, tmp_path)

    assert len(resources_) == 1
    assert resources_[0].type == "sqlite"
    assert resources_[0].url == "https://example.com"
    assert resources_[0].destination == tmp_path / "test.sql"
    assert resources_[0].database_file is None
