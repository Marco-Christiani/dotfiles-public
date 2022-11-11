#!/usr/bin/env python
import shlex
import subprocess
from functools import wraps
from pathlib import Path

import dmenu
import fire

option_registry = {}


def register_option(label):
    def decorate(fn):
        option_registry[label] = fn

        @wraps(fn)
        def wrapper(*args, **kwargs):
            return fn(*args, **kwargs)
        return wrapper
    return decorate


@register_option(label='dt-scripts')
def distrotube_scripts():
    path = Path('~/3rd-party-github/dmscripts/scripts/dm-hub').expanduser()
    return subprocess.call(shlex.split(f'bash {path}'))


def register_scripts(folder_path,  exts=('.sh', '.zsh', '.py')):
    for fpath in Path(folder_path).absolute().iterdir():
        if fpath.suffix == '.py':
            @register_option(label=fpath.name)
            def _callback():
                return subprocess.call(shlex.split(f'python {fpath}'))

        elif fpath.suffix == '.sh':
            @register_option(label=fpath.name)
            def _callback():
                return subprocess.call(shlex.split(f'bash {fpath}'))

        elif fpath.suffix == '.zsh':
            @register_option(label=fpath.name)
            def _callback():
                return subprocess.call(shlex.split(f'zsh {fpath}'))


def get_config():
    print(option_registry)


def main():
    if selection := dmenu.show(list(option_registry.keys()), lines=20, case_insensitive=True,):
        func = option_registry[selection]
        func()
    return 0


if __name__ == "__main__":
    # dmenu-options/ is sibling of this file
    option_dir = Path(__file__).absolute().parent.joinpath('dmenu-options')
    register_scripts(option_dir)
    fire.Fire(dict(run=main, config=get_config))
