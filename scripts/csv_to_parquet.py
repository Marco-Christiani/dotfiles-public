#!/usr/bin/env python
import os
from pathlib import Path

import fire
import pandas as pd


def main(path: str, index_col: int = 0, parse_dates: bool = True, dest_subdir: str = None):
    src_path = Path(path).resolve().absolute()
    assert src_path.exists()
    files = [src_path] if src_path.is_file() else list(src_path.glob('*.csv'))
    dest_folder = src_path
    if dest_subdir:
        dest_folder = src_path.joinpath(dest_subdir)
        if not dest_folder.exists():
            print('Destination folder not found:', dest_folder)
            resp = input('Would you like to create the folder? [y/n] ').strip().lower()
            if resp == 'y':
                os.makedirs(dest_folder, exist_ok=True)
                print('Created. Destination folder is:', dest_subdir)
            else:
                print('Wont create it. Exiting.')
                return 0
    print(f'Found {len(files)} files to convert.')
    print('[c] Continue')
    print('[e] Exit')
    resp = input('Continue? [c/e] ').strip().lower()
    if resp != 'c':
        print('Exiting')
        return 0

    for csv_path in files:
        print('Converting', csv_path.name)
        dest_file = dest_folder.joinpath(csv_path.with_suffix('.parquet').name)
        print('Parquet Destination:', dest_file)
        if resp == 'c':
            print('\t[c] Convert and continue continue')
            print('\t[a] Convert all without confirmation')
            print('\t[s] Skip')
            print('\t[e] Exit')
            resp = input('\tConvert file? [c/a/s/e] ').strip().lower()
            if resp in ['c', 'a']:
                print('Converting')
            elif resp == 's':
                resp = 'c'
                continue
            else:
                print('Exiting')
                return 0
        df = pd.read_csv(csv_path, index_col=index_col, parse_dates=parse_dates)
        df.to_parquet(dest_file)
        print('\tWrote file.')
    return 0


if __name__ == "__main__":
    fire.Fire(main)
