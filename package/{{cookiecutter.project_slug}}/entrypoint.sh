#!/usr/bin/env sh

# Dockerized app run script

set -e

if "${DEBUG}"; then
  echo '--- ENVIRONMENT DEBUG INFORMATION ---'
  python3 --version
  echo '--- packages:'
  pip freeze
  echo '--- files:'
  ls -hal
  echo '--- container:'
  echo "build: ${VERSION} ${REVISION} ${TIMESTAMP}"]
  echo '-----------------------------------'
fi

python3 -OOm {{ cookiecutter.project_slug }} "$@"
