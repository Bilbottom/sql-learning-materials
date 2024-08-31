"""
Unit tests for the ``src/resources`` package.
"""

import gzip
import pathlib

import pytest

import src.resources.__main__ as resources

ResourceTOML = tuple[str, dict[str, str]]


@pytest.fixture
def zipped_file(tmp_path: pathlib.Path) -> pathlib.Path:
    """
    A zipped file in a temporary location.
    """
    file = tmp_path / "test.txt.gz"
    with gzip.open(file, "wb") as f:
        f.write(b"Hello, world!")

    return file


@pytest.fixture
def resource_toml() -> ResourceTOML:
    """
    A resource as a tuple of a string and a dictionary.
    """
    return (
        "test-resource",
        {
            "url": "https://example.com",
            "destination": "test.sql",
        },
    )


@pytest.fixture
def resource() -> resources.Resource:
    """
    A custom resource object.
    """
    return resources.Resource(
        type_=resources.DatabaseType.SQLITE,
        name="test-resource",
        url="https://example.com",
        destination=pathlib.Path("test.sql"),
        database_file=pathlib.Path("test.db"),
        skip=False,
    )


def test__unzip_file(zipped_file: pathlib.Path):
    """
    Test the ``_unzip_file`` function.
    """
    resources._unzip_file(zipped_file)

    assert zipped_file.with_suffix("").exists()


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


def test__resource(resource: resources.Resource):
    """
    Test the instantiation of the ``Resource`` class.
    """
    assert resource.type == "sqlite"
    assert resource.url == "https://example.com"
    assert resource.destination == pathlib.Path("test.sql")
    assert resource.database_file == pathlib.Path("test.db")
    assert str(resource) == (
        "Resource("
        "type_='sqlite', "
        "name='test-resource', "
        "url='https://example.com', "
        "destination='test.sql', "
        "database='test.db', "
        "skip=False"
        ")"
    )
    assert repr(resource) == str(resource)


def test__resource__from_dict(
    tmp_path: pathlib.Path, resource_toml: ResourceTOML
):
    """
    Test the ``from_dict`` method of the ``Resource`` class.
    """
    resource = resources.Resource.from_dict(
        type_=resources.DatabaseType.SQLITE,
        resource=resource_toml,
        destination_root=tmp_path,
    )

    assert resource.type == "sqlite"
    assert resource.url == "https://example.com"
    assert resource.destination == tmp_path / "test.sql"
    assert resource.database_file is None


def test__resource__get_resource(
    monkeypatch: pytest.MonkeyPatch,
    tmp_path: pathlib.Path,
    resource: resources.Resource,
):
    """
    Test the ``get_resource`` method of the ``Resource`` class.
    """
    import urllib.request

    def mock_urlretrieve(url, filename):
        """
        Mock the ``urlretrieve`` function, which downloads a file from ``url``
        and saves it to ``filename``.
        """
        with open(filename, "wb") as f:
            f.write(b"Hello, world!")

    monkeypatch.setattr(urllib.request, "urlretrieve", mock_urlretrieve)
    monkeypatch.setattr(resource, "destination", tmp_path / "test.sql")

    resource.get_resource()

    assert resource.destination.exists()
