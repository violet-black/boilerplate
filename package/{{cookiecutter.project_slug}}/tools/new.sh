#!/usr/bin/env sh

# Initialize a developer's environment for the project
#
# This script should be run by a developer from a project root dir
# after creating a new repository from a template.
# It will init a git repository if needed, install all base
# and dev requirements and pycharm files and will activate
# all git hooks.
# It will also add files to git and make an initial commit.
#
# Example:
#
#   tools/new.sh
#

set -e

main() {

  . ./venv/bin/activate || true
  . .env || true
  . ./tools/_lib.sh

  CUR_DIR="${PWD}"

  echo 'Preparing a new project environment...'

  git rev-parse HEAD && exit 1 || true

  init_project
  git_make_initial_commit

  cd "${CUR_DIR}"

  echo 'OK'

}

main
