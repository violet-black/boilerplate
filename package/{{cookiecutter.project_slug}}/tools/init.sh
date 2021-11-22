#!/usr/bin/env sh

# Initialize a developer's environment for the project
#
# This script should be run by a developer from a project root dir
# after cloning an existing repository.
# It will init a git repository if needed, install all base
# and dev requirements and pycharm files and will activate
# all git hooks.
#
# Example:
#
#   tools/init.sh
#

set -e

main() {

  . ./venv/bin/activate || true
  . .env || true
  . ./tools/_lib.sh

  CUR_DIR="${PWD}"

  echo 'Initializing dev environment...'

  init_project

  cd "${CUR_DIR}"

  echo 'OK'

}

main
