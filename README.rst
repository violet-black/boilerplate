Readme
------

.. list-table::

   * - Python version
     - >= `3.6 <https://docs.python.org/3.6/>`_
   * - Dependencies
     - `cookiecutter <https://cookiecutter.readthedocs.io>`_


Usage
_____

.. code-block:: console

  pip install cookiecutter
  cookiecutter https://github.com/violet-black/boilerplate-vb --directory package


Parameters
__________

- `type` - "package" - normal package, "application" - executable
- `minimum_python_version`
- `maximum_python_version`
- `python_versions` - set automatically: list of all minor python versions
- `line_length` - max allowed line length for code and doc lines
- `project_name` - human-readable project name used in docs
- `version` - initial package version
- `project_slug` - project directory and package name in python
- `package_name` - package name in PyPI
- `vcs_project_name` - repository name in VCS
- `vcs` - select VCS host (github, gitlab)
- `vcs_username` - username or group name in VCS
- `codecov_username` - username in codecov.io used in coverage reports
- `vcs_url` - VCS project URL
- `email` - author email
- `author` - author name
- `project_short_description` - short description used in PyPI
- `license` - select license type
