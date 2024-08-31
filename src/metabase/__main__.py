"""
Stolen from:

- https://dev.to/bowmanjd/http-calls-in-python-without-requests-or-other-external-dependencies-5aj1
"""

from __future__ import annotations

import json
import tomllib
import urllib.error
import urllib.parse
import urllib.request
from email.message import Message
from typing import Any, Literal, NamedTuple, TypedDict

from _constants import SRC


class Response(NamedTuple):
    body: str
    headers: Message
    status: int
    error_count: int = 0

    def json(self) -> Any:
        """
        Decode body's JSON.

        Returns:
            Pythonic representation of the JSON object
        """
        try:
            output = json.loads(self.body)
        except json.JSONDecodeError:
            output = ""
        return output


def request(  # noqa: PLR0913
    url: str,
    data: dict | None = None,
    params: dict | None = None,
    headers: dict | None = None,
    method: str = "GET",
    data_as_json: bool = True,
    error_count: int = 0,
) -> Response:
    """
    Stolen from:

    - https://dev.to/bowmanjd/http-calls-in-python-without-requests-or-other-external-dependencies-5aj1
    """
    if not url.casefold().startswith("http"):
        raise urllib.error.URLError(
            "Incorrect and possibly insecure protocol in url"
        )
    method = method.upper()
    request_data = None
    headers = headers or {}
    data = data or {}
    params = params or {}
    headers = {"Accept": "application/json", **headers}

    if method == "GET":
        params = {**params, **data}
        data = None

    if params:
        url += "?" + urllib.parse.urlencode(params, doseq=True, safe="/")

    if data:
        if data_as_json:
            request_data = json.dumps(data).encode()
            headers["Content-Type"] = "application/json; charset=UTF-8"
        else:
            request_data = urllib.parse.urlencode(data).encode()

    httprequest = urllib.request.Request(  # noqa: S310
        url,
        data=request_data,
        headers=headers,
        method=method,
    )

    try:
        with urllib.request.urlopen(httprequest) as httpresponse:  # noqa: S310
            response = Response(
                headers=httpresponse.headers,
                status=httpresponse.status,
                body=httpresponse.read().decode(
                    httpresponse.headers.get_content_charset("utf-8")
                ),
            )
    except urllib.error.HTTPError as e:
        response = Response(
            body=str(e.reason),
            headers=e.headers,
            status=e.code,
            error_count=error_count + 1,
        )

    return response


class Details(TypedDict):
    host: str
    port: str
    user: str
    password: str
    db: str


class Database(TypedDict):
    name: str
    engine: Literal["postgres", "sqlserver", "sqlite"]
    details: Details
    is_full_sync: bool | None
    is_on_demand: bool | None
    schedules: list | None
    auto_run_queries: bool | None
    cache_ttl: int | None


class MetabaseConnector:
    """
    Metabase connector class.
    """

    url: str = "http://localhost:3000/api/"
    username: str
    password: str
    _token: str

    def __init__(
        self,
        username: str,
        password: str,
        token: str | None = None,
    ) -> None:
        self.username = username
        self.password = password
        self._token = token
        if not self._token:
            self.login()

    @property
    def headers(self):
        headers_ = {
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
        if self._token:
            headers_["X-Metabase-Session"] = self._token

        return headers_

    def get(self, endpoint: str) -> Response:
        """
        Get from Metabase.
        """
        return request(
            url=self.url + endpoint,
            method="GET",
            headers=self.headers,
        )

    def post(self, endpoint: str, payload: dict | None = None) -> Response:
        """
        Post to Metabase.
        """
        return request(
            url=self.url + endpoint,
            data=payload,
            method="POST",
            headers=self.headers,
        )

    def setup(self) -> None:
        """
        Setup Metabase.

        https://www.metabase.com/docs/latest/api/setup
        """
        response = self.post("setup")
        self._token = response.json()["id"]

    def login(self) -> None:
        """
        Login to Metabase.
        """
        payload = {
            "username": self.username,
            "password": self.password,
        }

        response = self.post("session", payload)
        self._token = response.json()["id"]

    def add_database(self, database: Database) -> None:
        """
        Add a database.

        https://www.metabase.com/docs/latest/api/database
        """
        self.post("database", database)


def main() -> None:
    metabase = MetabaseConnector(
        username=input("Metabase username: "),
        password="Test@12345",  # noqa: S106
    )
    databases = tomllib.loads((SRC / "metabase/databases.toml").read_text())

    for database in databases["databases"]:
        metabase.add_database(database)


if __name__ == "__main__":
    main()
