"""Template values validation."""

import re
import sys


def main():

    print('Checking for empty lines.')
    for v in (
        '{{ cookiecutter.project_name }}',
        '{{ cookiecutter.vcs_username }}',
        '{{ cookiecutter.codecov_username }}',
        '{{ cookiecutter.email }}',
        '{{ cookiecutter.author }}',
        '{{ cookiecutter.project_short_description }}'
    ):
        check_value_not_empty(v)

    print('Checking versions PEP440 compatibility.')
    for v in (
        '{{ cookiecutter.version }}',
        '{{ cookiecutter.minimum_python_version }}',
        '{{ cookiecutter.maximum_python_version }}'
    ):
        check_version_pattern(v)

    print('Checking minimum and maximum python version.')
    init_python_versions(
        '{{ cookiecutter.minimum_python_version }}',
        '{{ cookiecutter.maximum_python_version }}'
    )


def check_value_not_empty(v: str):
    if not v.strip():
        print('ERROR: empty values are not allowed!')
        sys.exit(1)


VERSION_PATTERN = r"""
v?
(?:
    (?:(?P<epoch>[0-9]+)!)?                           # epoch
    (?P<release>[0-9]+(?:\.[0-9]+)*)                  # release segment
    (?P<pre>                                          # pre-release
        [-_\.]?
        (?P<pre_l>(a|b|c|rc|alpha|beta|pre|preview))
        [-_\.]?
        (?P<pre_n>[0-9]+)?
    )?
    (?P<post>                                         # post release
        (?:-(?P<post_n1>[0-9]+))
        |
        (?:
            [-_\.]?
            (?P<post_l>post|rev|r)
            [-_\.]?
            (?P<post_n2>[0-9]+)?
        )
    )?
    (?P<dev>                                          # dev release
        [-_\.]?
        (?P<dev_l>dev)
        [-_\.]?
        (?P<dev_n>[0-9]+)?
    )?
)
(?:\+(?P<local>[a-z0-9]+(?:[-_\.][a-z0-9]+)*))?       # local version
"""

VERSION_REGEX = re.compile(
    r'^\s*' + VERSION_PATTERN + r'\s*$',
    re.VERBOSE | re.IGNORECASE,
)


def check_version_pattern(v: str):
    if not VERSION_REGEX.match(v):
        print('ERROR: %s is not a valid PEP440 version number!' % v)
        sys.exit(1)


def init_python_versions(min_version: str, max_version: str):

    def _strip_version(version: str) -> int:
        version = version.strip().split('.')
        major, minor = int(version[0]), int(version[1])
        if major != 3:
            print('Major python versions other than "3" are not supported yet.')
            sys.exit(1)
        return minor

    min_version, max_version = _strip_version(min_version), _strip_version(max_version)
    if min_version > max_version:
        print('Maximum python version should be greater than minimum.')
        sys.exit(1)


main()
