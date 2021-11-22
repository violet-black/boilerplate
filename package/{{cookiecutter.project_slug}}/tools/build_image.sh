#!/usr/bin/env sh

# Create a new docker image
#
# This script will try to build a docker image locally.
#
# Examples:
#
#   tools/build_image.sh
#

set -e

main() {

  . ./venv/bin/activate || true
  . .env || true
  . ./tools/_lib.sh

  CUR_DIR="${PWD}"

  # checking that the daemon is running

  build_docker_image

  cd "${CUR_DIR}"

  echo 'Images:'
  docker image ls | grep {{ cookiecutter.package_name }}

}

main
