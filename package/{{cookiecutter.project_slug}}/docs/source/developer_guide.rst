Developer's guide
-----------------

Setup
^^^^^

Clone all project files and fill the project `.env` file with your git credentials
and personal GPG key data.

Use the provided setup script to setup the project for development. An active `venv`
and `pip` and also `git` are required. The script must be run from the project root.

.. code-block::

  python3 -m venv venv
  . ./venv/bin/activate

  tools/init.sh


The script will init the repository, install the package and its dependencies. If you
are using PyCharm then run settings will also be copied (however you may need to reopen
the project for changes to take effect).


Making changes
^^^^^^^^^^^^^^

This project uses `gitlab flow <https://docs.gitlab.com/ee/topics/gitlab_flow.html>`__.

It means that there is a single `master` branch and there are no other branches except feature branches. However
when there is a need to support an older version in production, a 'version' branch is created from a tagged commit
and all release support is done and pushed to this branch.

Open a new `issue <{{ cookiecutter.vcs_url }}/-/issues>`__ before making code changes, reference this
issue in your branch by its issue number. All branch names **must** follow a simple rule:

.. code-block::

  <issue>-<change_type>-<description>


Where `<change_type>` may be:

- `feature` - new feature
- `bugfix` - bug fix
- `doc` - change to the documentation
- `misc` - changes internal to the repo like CI, test and build changes
- `removal` - deprecations and removals of an existing feature or behavior


Use `-` instead of `_` or other symbols.

.. code-block::

  112-feature-cache-reinitialization


Project structure
^^^^^^^^^^^^^^^^^

You should stick to the standard layout when developing the project.

Files
_____

- `{{ cookiecutter.project_slug }}/` - python project files
- `{{ cookiecutter.project_slug }}/resources/` - project resources, see `importlib.resources <https://docs.python.org/3/library/importlib.html#module-importlib.resources>`__
- `data/` - other project data (fixtures etc)
- `docs/` - sphinx documentation files, see `Docs`_
- `etc/` - other configuration files not used directly by the project (db configs, docker configs, linux dependencies)
- `requirements/` - auto-generated requirements (do not edit them, edit `setup.cfg` instead, see `Packaging`_)
- `tests/` - pytest tests, see `Testing`_
- `tools/` - additional executable not referenced in the project (sh and py scripts, helpers, hooks)


Packaging
^^^^^^^^^

This project uses `twine <https://twine.readthedocs.io/en/latest/>`__ and
`setup.cfg <https://docs.python.org/3/distutils/configfile.html>`__ for packaging.
It uses `wheel <https://www.python.org/dev/peps/pep-0427/>`__ packages by default.

Since this project uses CI hooks there is no need to manually build packages. You just need
to change `__init__.py/__version__` in the master branch and make a commit. A version tag will
be automatically created and on push a new package will be built automatically
(don't forget to `git push --tags` though).

However you can build and publish it manually
(just make sure that your `.pypirc <https://packaging.python.org/specifications/pypirc/>`__ is
configured):

.. code-block::

  pip install -r requirements/build.txt
  python -m build
  python -m twine upload --repository pypi dist/{{ cookiecutter.project_slug }}.whl


- Do not use requirements files directly. Write your dependencies in a most concise way into setup.cfg
  or into `requirements/*.in` files, `*.txt` will be
  created automatically on commit by `pip-compile <https://pip-tools.readthedocs.io/en/latest/>`__ hook
- Do not write anything in setup.py
- Versioning should be consistent and compatible with `PEP440 <https://www.python.org/dev/peps/pep-0440/>`__

Files
_____

- `setup.cfg` - package config
- `setup.py` - additional setup instructions
- `requirements/*.in` - requirements instructions for pip-compile
- `requirements/*.txt` - auto-generated frozen requirement files


Testing
^^^^^^^

This project uses `pytest <http://pytest.org>`__ for all tests. CI jobs and git hooks will automatically
run all tests `marked as <https://docs.pytest.org/en/6.2.x/example/markers.html>`__ `unittest` from `tests/` directory.

- Write all your tests in `tests/` but try to keep subdirectories consistent with the package structure.
- Use `doctests <https://docs.python.org/3/library/doctest.html>`__ whenever possible
- Use pytest `markers <https://docs.pytest.org/en/6.2.x/example/markers.html>`__ to distinguish between test types;
  new markers can be added in `setup.cfg` pytest section
- Use `tox <https://tox.wiki/en/latest/index.html>`__ more or less frequently to test for python versions incompatibilities.

Files
_____

- `pyproject.toml` - contains pytest configs
- `tests/*` - all tests (except doctests) should be here
- `conftest.py` - pytest hooks
- `tox.ini` - tox configuration


QA
^^

Q/A scripts use git hooks and `pre-commit <http://pre-commit.com>`__ library which is installed
automatically in dev mode. There are a several hooks worth noting, because they won't allow to
commit unless you do everything right:

- `flake8 <https://flake8.pycqa.org>`__, `pydocstyle <http://www.pydocstyle.org>`__ and other code style checks
- `pytest <https://pytest.org>`__
- `isort <https://github.com/PyCQA/isort>`__ - sorting and organizing python imports
- `pyupgrade <https://github.com/asottile/pyupgrade>`__ - automatically upgrades python syntax to modern python standards
- `black <https://black.readthedocs.io/en/stable/>`__ python code formatter
- `rst-lint <https://github.com/twolfson/restructuredtext-lint>`__ - checks RST documentation files
- `pip-compile <https://pip-tools.readthedocs.io/en/latest/>`__ - resolves dependencies and auto-generates requirements/ files

Files
_____

- `.editorconfig` - standard text editor configuration
- `.idea/{{ cookiecutter.project_slug }}.iml` - PyCharm directory markings
- `.idea/runConfigurations` - PyCharm default run configurations (you should copy them to .idea/runConfigurations if needed)
- `pyproject.toml` - contains tools and linters configs
- `.pre-commit-config.yaml` - `pre-commit <http://pre-commit.com>`__ configuration for local development
- `.pre-commit-config-ci.yaml` - `pre-commit <http://pre-commit.com>`__ configuration for CI jobs
{% if cookiecutter.vcs == 'gitlab' %}
- `.gitlab/issue_templates/` - gitlab templates for the issue tracker
- `.gitlab/merge_request_templates/` - gitlab templates for merge requests
{% elif cookiecutter.vcs == 'github' %}
- `.github/ISSUE_TEMPLATE/` - github templates for the issue tracker
- `.github/pull_request_template.md` - github pull request template
{% endif %}


CI
^^

Use CI configs to store deployment and test hooks to increase your code quality.

Files
_____

{% if cookiecutter.vcs == 'gitlab' %}
- `.gitlab-ci.yml` - `Gitlab CI <https://docs.gitlab.com/ee/ci/yaml/>`__ pipelines
{% elif cookiecutter.vcs == 'github' %}
- `.github/workflows/` - `Github actions <https://docs.github.com/en/actions/quickstart>`__
- `.readthedocs.yaml` - `ReadTheDocs <https://docs.readthedocs.io/en/stable/config-file/index.html>`__ configuration
{% endif %}

Variables
_________

There are two pipelines configured: for gitlab and for github. These pipelines
use a several env variables which should be put in CI secrets section:

- `PYPI_API_TOKEN` - `PyPI token <https://pypi.org/help/#apitoken>`__ for this repo
- `CODECOV_TOKEN` - `codecov.io <https://about.codecov.io>`__ API token


Docs
^^^^

**All** documentation files (except LICENSE) must be
in `RST <https://github.com/ralsina/rst-cheatsheet/blob/master/rst-cheatsheet.rst>`__ format.

Usually CI should automatically build the latest version of documentation
to the project docs

If you need to build the docs manually, you can do it using `Sphinx <https://www.sphinx-doc.org/en/master/>`__.
This command will build docs in `docs/build/html`. **Do not commit them to the project!**

.. code-block::

  pip install -r requirements/docs.txt
  pip install sphinx
  cd docs
  make html


Files
_____

- `LICENSE` - project license file
- `README.rst` - basic readme file
- `CHANGES.rst` - minor and major version changes should be listed here
- `docs/` - `Sphinx <https://www.sphinx-doc.org/en/master/>`__ files
