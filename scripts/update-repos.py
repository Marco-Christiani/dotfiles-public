#!/home/marco/anaconda3/bin/python3
import os
from pathlib import Path

import git


repo_dir = Path(os.environ.get('REPO_DIR', '~/Github')).absolute()

repos = [
    'zet',
]

for r in repos:
    repo_path = repo_dir.joinpath(r)
    git.Git(repo_path).execute(['git', 'pull'])
