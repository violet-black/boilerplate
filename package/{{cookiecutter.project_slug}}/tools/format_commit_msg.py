#!/usr/bin/env python3

import re
from argparse import ArgumentParser
from pathlib import Path
from textwrap import dedent, wrap
from typing import Optional, Sequence


COMMIT_MSG_PATH = '.git/COMMIT_EDITMSG'
MSG_FORMAT = r'^(?P<subject>[^\n]{5,50})(\n+(?P<body>.+))?'
BODY_WIDTH = 72


def _get_arg_parser() -> ArgumentParser:  # pragma: no cover
    parser = ArgumentParser(description='Format and validate commit messages.')
    parser.add_argument(
        '--format', dest='format', default=MSG_FORMAT, help=f'custom commit message format (default={MSG_FORMAT})'
    )
    return parser


def get_commit_msg() -> Optional[str]:
    """Return current commit message text."""
    if not Path(COMMIT_MSG_PATH).exists():
        return None
    with open(COMMIT_MSG_PATH) as f:
        msg = f.read()
    return msg


def write_commit_msg(msg: str) -> None:
    """Write commit message back to the file to proceed with a commit."""
    with open(COMMIT_MSG_PATH, 'w') as f:
        f.write(msg)


def format_msg(subject: str, body: Optional[str]) -> str:
    """Format the commit message text according to git best practices."""
    subject = subject.strip().rstrip('.').capitalize()
    if body is None:
        return subject
    else:
        body = dedent(body)
        body = body.strip()
        body = wrap(body, width=BODY_WIDTH)
        return f'{subject}\n\n{body}\n'


def main(argv: Optional[Sequence[str]] = None) -> int:
    """Run a commit hook function."""
    print('Checking commit message format ...')
    args = _get_arg_parser().parse_args(argv)
    msg = get_commit_msg()
    msg = msg.strip()
    if not msg:
        print('No commit message provided.')
        return 1

    match = re.match(args.format, msg)
    if not match:
        print('Invalid commit message format.')
        print('See commit message best practices: https://chris.beams.io/posts/git-commit/.')
        return 1

    msg = format_msg(match['subject'], match['body'])
    write_commit_msg(msg)
    print('OK')
    return 0


if __name__ == '__main__':  # pragma: no cover
    exit(main())
