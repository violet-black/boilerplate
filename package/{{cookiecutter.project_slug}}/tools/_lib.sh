#!/usr/bin/env sh

# Library functions

set -e

# Set git repository attributes such as username and GPG signing
git_set_attributes() {

  if [ -n "${GIT_USERNAME}" ]; then
    git config user.name "${GIT_USERNAME}"
  fi

  if [ -n "${GIT_EMAIL}" ]; then
    git config user.email "${GIT_EMAIL}"
  fi

  # GPG signing should only be set if all the values are filled

  for value in "${GIT_GPG_PROGRAM}" "${GIT_GPG_KEY}"; do
    if [ -z "${value}" ]; then
      return
    fi
  done

  git config push.followTags true
  git config tag.forceSignAnnotated true
  git config user.gpgsign true
  git config gpg.program "${GIT_GPG_PROGRAM}"
  git config user.signingkey "${GIT_GPG_KEY}"

}

# Make an initial commit for a new project
git_make_initial_commit() {

  COMMIT_MSG='Initial commit'

  git add * || true
  git add .* || true
  git add .gitlab || true
  git add -f .editorconfig .gitignore .pre-commit-config.yaml .pre-commit-config-ci.yaml .bumpversion.cfg || true
  git add -f .dockerignore || true
  git add -f .gitlab-ci.yml || true
  pre-commit run --hook-stage commit || true
  SKIP="requirements-base,requirements-dev" git commit -am "${COMMIT_MSG}"

}

# Update .idea files with project files
idea_update_project_files() {

  mkdir .idea/runConfigurations || true
  cp -n etc/idea/runConfigurations/* .idea/runConfigurations/ || true
  cp etc/idea/{{ cookiecutter.project_slug }}.iml .idea/ || true

}

# Install development version of the current project
setup_dev_project() {

  pip install -U pip setuptools || true
  pip install -r requirements/dev.txt
  pip install -e .[dev]
  pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type post-commit

}

# Initialize the project for development
init_project() {

  idea_update_project_files
  git init
  git_set_attributes
  setup_dev_project

}

# Build a docker image for the project
build_docker_image() {

  # checking daemon availability first

  docker ps

  REVISION=$(git rev-parse --short HEAD)
  VERSION=$(git --no-pager tag --points-at | head -n 1)
  TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

  if [ -n "${VERSION}" ]; then
    docker build \
      --build-arg "VERSION=${VERSION}" \
      --build-arg "REVISION=${REVISION}" \
      --build-arg "TIMESTAMP=${TIMESTAMP}" \
      -t "${DOCKER_REGISTRY_ADDR}/{{ cookiecutter.vcs_username }}/{{ cookiecutter.package_name }}:latest" \
      -t "${DOCKER_REGISTRY_ADDR}/{{ cookiecutter.vcs_username }}/{{ cookiecutter.package_name }}:${REVISION}" \
      -t "${DOCKER_REGISTRY_ADDR}/{{ cookiecutter.vcs_username }}/{{ cookiecutter.package_name }}:${VERSION}" \
      .
  else
    docker build \
      --build-arg "VERSION=${VERSION}" \
      --build-arg "REVISION=${REVISION}" \
      --build-arg "TIMESTAMP=${TIMESTAMP}" \
      -t "${DOCKER_REGISTRY_ADDR}/{{ cookiecutter.vcs_username }}/{{ cookiecutter.package_name }}:latest" \
      -t "${DOCKER_REGISTRY_ADDR}/{{ cookiecutter.vcs_username }}/{{ cookiecutter.package_name }}:${REVISION}" \
      .
  fi

}
