#!/home/marco/anaconda3/bin/python
import os
import pathlib

import tasklib
from ripgrepy import Ripgrepy  # type: ignore

REPO_DIR = pathlib.Path(os.getenv('REPO_DIR'))
ZET_DIR = REPO_DIR.joinpath('zet')


def grep_notes():
    # rg = Ripgrepy('#inbox', ZET_DIR.joinpath('journals'))
    rg = Ripgrepy('#inbox', ZET_DIR)
    # result = rg.glob('!bak/').with_filename().line_number().json().run()
    result = rg.glob('!bak/').json().run()
    matches = result.as_dict

    tasks = []
    for m in matches:
        text = m['data']['lines']['text']
        text = text.replace('#inbox', '')  # remove the inbox tag
        text = text.replace('[[', '').replace(']]', '')
        text = text.replace('-', '').strip()
        # fpath = m['data']['path']['text']
        tasks.append(text)
    return tasks


def taskwarrior(tasks):
    tw = tasklib.TaskWarrior(create=False)
    existing_tasks = [t['description'] for t in tw.tasks]

    for t in tasks:
        if t not in existing_tasks:
            task = tasklib.Task(tw, description=t, tags=['inbox'])
            task.save()
            print('----- New Task:', t)
        else:
            print('Existing task:', t)


if __name__ == "__main__":
    task_list = grep_notes()
    taskwarrior(task_list)
