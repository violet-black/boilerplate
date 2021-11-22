
.. image:: https://badge.fury.io/py/{{ cookiecutter.package_name }}.svg
    :target: https://pypi.org/project/{{ cookiecutter.package_name }}
    :alt: Latest package version
{% if cookiecutter.vcs == 'github' %}
.. image:: https://readthedocs.org/projects/{{ cookiecutter.vcs_project_name }}/badge/?version=latest
    :target: https://{{ cookiecutter.vcs_project_name }}.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation

.. image:: https://github.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/actions/workflows/hooks.yml/badge.svg
    :target: https://github.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/actions/workflows/hooks.yml
    :alt: CI status

.. image:: https://github.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/actions/workflows/publish.yml/badge.svg
    :target: https://github.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/actions/workflows/publish.yml
    :alt: Build status
{% elif cookiecutter.vcs == 'gitlab' %}
.. image:: https://shields.io/badge/docs-passing-green
    :target: https://{{ cookiecutter.vcs_username }}.gitlab.io/{{ cookiecutter.vcs_project_name }}/index.html
    :alt: Documentation

.. image:: https://gitlab.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/badges/master/pipeline.svg
    :target: https://gitlab.com/{{ cookiecutter.vcs_username }}/{{ cookiecutter.vcs_project_name }}/-/pipelines/latest
    :alt: CI status
{% endif %}
.. image:: https://codecov.io/gh/{{ cookiecutter.codecov_username }}/{{ cookiecutter.vcs_project_name }}/branch/master/graph/badge.svg
    :target: https://codecov.io/gh/{{ cookiecutter.codecov_username }}/{{ cookiecutter.vcs_project_name }}
    :alt: Coverage report

.. image:: https://img.shields.io/pypi/dm/{{ cookiecutter.package_name }}.svg
    :target: https://pypistats.org/packages/{{ cookiecutter.package_name }}
    :alt: Downloads

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
   :target: https://github.com/psf/black
   :alt: Code style - Black

.. list-table::

   * - Package
     - `{{ cookiecutter.package_name }} <https://badge.fury.io/py/{{ cookiecutter.package_name }}>`_
   * - Python version
     - >= `{{ cookiecutter.minimum_python_version }} <https://docs.python.org/{{ cookiecutter.minimum_python_version }}/>`_
   * - Documentation
     - {% if cookiecutter.vcs == 'github' %}`here <https://{{ cookiecutter.vcs_project_name }}.readthedocs.io/en/latest/?badge=latest>`_{% elif cookiecutter.vcs == 'gitlab' %}`here <https://{{ cookiecutter.vcs_username }}.gitlab.io/{{ cookiecutter.vcs_project_name }}/index.html>`_{% endif %}


{{ cookiecutter.project_name | capitalize }}
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

{{ cookiecutter.project_short_description | capitalize }}


Installation
^^^^^^^^^^^^

For users:

.. code-block::

    pip install {{ cookiecutter.package_name }}


For developers:

.. code-block::

    pip install -e git+{{ cookiecutter.vcs_url }}[dev]


Usage
^^^^^



Testing
^^^^^^^

Run `pytest` command to test the package.
