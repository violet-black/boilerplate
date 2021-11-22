#!/usr/bin/env sh

# Create a new release
#
# bump2version will create a new 'bump' commit and add a new tag automatically
# Note that although it creates packages locally they won't be pushed to PyPI.
# You have to push commit with --tags to your VCS host to create an official release.
# Local releases will be stored in `dist/` directory.
#
# Parameters:
#
#   - $1 string - version type: major / minor / patch
#
# Examples:
#
#   tools/release.sh minor
#

set -e

VERSION="$1"

main() {

  . ./venv/bin/activate || true
  . .env || true
  . ./tools/_lib.sh

  CUR_DIR="${PWD}"

  if [ "${VERSION}" != patch ] && [ "${VERSION}" != minor ] && [ "${VERSION}" != major ]; then
    echo 'Version type must be specified, one of: major minor patch'
    exit 1
  fi

  pre-commit run --hook-stage manual pytest
  pip install -U pip setuptools wheel build || true
  python -m build --wheel -o .cache/build/    # test build before a new version commit
  bumpversion "${VERSION}" {{ cookiecutter.project_slug }}/__init__.py
  python -m build --wheel                     # real build into dist/

  cd "${CUR_DIR}"

  echo 'Packages:'
  echo "file://${CUR_DIR}/dist"

}

main
