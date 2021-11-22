"""Template post-generation operations."""

import os
import shutil
import stat
from pathlib import Path

EXECUTABLE_SCRIPTS = [
    'tools/*.sh',
    'tools/*.py',
    'entrypoint.sh'
]

REMOVE_PATHS = [

    # remove VCS-specific files

    '{% if cookiecutter.vcs != "github" %}.github{% endif %}',
    '{% if cookiecutter.vcs != "github" %}.readthedocs.yaml{% endif %}',
    '{% if cookiecutter.vcs != "gitlab" %}.gitlab{% endif %}',
    '{% if cookiecutter.vcs != "gitlab" %}.gitlab-ci.yml{% endif %}',

    # remove app files if package is selected

    '{% if cookiecutter.type != "application" %}data{% endif %}',
    '{% if cookiecutter.type != "application" %}settings{% endif %}',
    '{% if cookiecutter.type != "application" %}Dockerfile{% endif %}',
    '{% if cookiecutter.type != "application" %}.dockerignore{% endif %}',
    '{% if cookiecutter.type != "application" %}etc/docker{% endif %}',
    '{% if cookiecutter.type != "application" %}{{ cookiecutter.project_slug }}/__main__.py{% endif %}',

]

RENAME_PATHS = [
    ('.env.sample', '.env')
]


def _normalize_path(p: str):
    p = p.strip()
    if p:
        return Path(p)


def remove_paths():
    for p in REMOVE_PATHS:
        p = _normalize_path(p)
        if not p:
            continue
        if p.exists():
            if p.is_dir():
                shutil.rmtree(str(p))
            else:
                p.unlink()


def rename_paths():
    for from_, to_ in RENAME_PATHS:
        from_, to_ = _normalize_path(from_), _normalize_path(to_)
        if not from_ or not to_:
            continue
        if from_.exists():
            from_.rename(to_)


def set_executable():
    for pattern in EXECUTABLE_SCRIPTS:
        pattern = pattern.strip()
        if not pattern:
            continue
        for p in Path('.').glob(pattern):
            if p.is_file():
                os.chmod(str(p), p.stat().st_mode | stat.S_IEXEC)


if __name__ == '__main__':
    remove_paths()
    rename_paths()
    set_executable()
