#!/usr/bin/python3
import os
import sys
import subprocess
from concurrent.futures import ProcessPoolExecutor

if len(sys.argv) != 3:
    print("usage: ./sort_music SRC_DIR DST_DIR")

SRC = sys.argv[1]
DST = sys.argv[2]

def get_all_files(src):
    for root, dirs, files in os.walk(SRC):
        for fname in files:
            yield os.path.join(root, fname)

def make_dirs_for_file(path):
    dir_name = os.path.dirname(path)
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)

def process_file(fname):
    #pass a tuple so it can be map'd with the Executor
    print (fname)
    relpath = os.path.relpath(fname, SRC)
    if fname.lower().endswith(".flac"):
        new_fname = os.path.join(DST, os.path.splitext(relpath)[0] + ".ogg")
        make_dirs_for_file(new_fname)
        subprocess.call(["ffmpeg", "-hide_banner", "-loglevel", "quiet", "-y", "-i", fname, "-map", "0:a:0", "-acodec", "libopus", "-b:a", "96000", new_fname], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, stdin=subprocess.DEVNULL)
    else:
        new_fname = os.path.join(DST, relpath)
        if os.path.exists(new_fname):
            return
        make_dirs_for_file(new_fname)
        os.symlink(fname, new_fname)

def main():
    with ProcessPoolExecutor() as executor:
        executor.map(process_file, get_all_files(SRC))

if __name__ == '__main__':
    main()
