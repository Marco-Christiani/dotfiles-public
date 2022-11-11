#!/usr/bin/env python
# from urllib.request import urlopen
# import fire
# from pytube import Playlist
# def get_playlist_links(url):
#     play_list = Playlist(url)
#     print(len(play_list))
#     for link in play_list:
#         print(link)
#     for video in play_list.videos:
#         name = video.title
#         print(name)
# if __name__ == "__main__":
#     fire.Fire(get_playlist_links)
from concurrent.futures import as_completed
from concurrent.futures import ThreadPoolExecutor

import pandas as pd
import pyperclip
from pytube import Playlist
from pytube import YouTube


def get_playlist(url):
    video_links = Playlist(url).video_urls

    def get_video_title(link):
        title = YouTube(link).title.replace('|', '-').replace('#', '')
        link = f'[{title}]({link})'
        return dict(Video=link)

    processes = []
    with ThreadPoolExecutor(max_workers=10) as executor:
        for url in video_links:
            processes.append(executor.submit(get_video_title, url))

    results = []
    for task in as_completed(processes):
        results.append(task.result())

    df = pd.DataFrame(results)
    return df


if __name__ == "__main__":
    playlist_link = "https://www.youtube.com/playlist?list=PL0ufgDOVAZ8puLTv7YHKoMq7RsIACUp3H"
    df = get_playlist(playlist_link)
    table = df.to_markdown(index=False)
    print(table)
    pyperclip.copy(table)
    print()
    print('Copied to clipboard!')
