#!/usr/bin/env python3

import sys
import argparse
import json
import re


def main():
    args = get_args()
    for filename in args.notebooks:
        with open(filename, 'r') as notebook_file:
            sections = '\n'.join('{0}{3} [{1}](#{2})'.format(
                                 '    ' * (len(s.split(' ')[0]) - 1),
                                 ' '.join(s.split(' ')[1:]),
                                 '-'.join(s.split(' ')[1:]),
                                 '*' if args.bullet else '{}.'.format(i + 1))
                            for i, s in enumerate(item for sublist in
                                [[re.sub('\n', '', line) for line in cell['source'] if line.startswith('#')]
                                  for cell in json.loads(notebook_file.read())['cells']
                                  if cell['cell_type'] == 'markdown'] for item in sublist))
        print('-' * len(filename))
        print(filename)
        print('# Table of Contents')
        print(sections)
        print('-' * len(filename))



def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('notebooks', metavar='N', type=str, nargs='+',
                        help=('Notebook(s) to analyze'))
    parser.add_argument('-b', '--bullet', action='store_true', default=False,
                        help='Use bullets instead of numbers')
    args = parser.parse_args()
    return args


if __name__ == '__main__':
    sys.exit(main())
