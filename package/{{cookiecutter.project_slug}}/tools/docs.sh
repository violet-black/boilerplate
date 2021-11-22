#!/usr/bin/env sh

# Build API documentation locally using Sphinx
#
# Resulting documentation will be stored at `docs/build/html/`.
#
# Example:
#
#   tools/docs.sh
#

set -e

main() {

  . ./venv/bin/activate || true
  . .env || true
  . ./tools/_lib.sh

  CUR_DIR="${PWD}"

  echo 'Building documentation locally...'

  pip install -r requirements/docs.txt
  pip install sphinx
  cd docs
  make html

  cd "${CUR_DIR}"

  echo 'Documentation index:'
  echo "file://${CUR_DIR}/docs/build/html/index.html"
  echo 'OK'

}

main
