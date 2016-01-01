#!/usr/bin/python
import os
import sys
import subprocess
import shutil

if len(sys.argv) != 3:
    print("usage: ./sort_music SRC_DIR DST_DIR")

SRC = sys.argv[1]
DST = sys.argv[2]
MUPRINT = "/home/andrew/bin/muprint"

def get_all_files(src):
    for root, dirs, files in os.walk(SRC):
        for fname in files:
            yield os.path.join(root, fname)

def get_new_fname(fname):
    subproc = subprocess.run([MUPRINT, "-s", "A%ua", "-s", "t%uf", "-r", "_", "%uA/%ub/%ut.%ue", fname], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, universal_newlines=True)
    new_fname = subproc.stdout
    if new_fname:
        return new_fname
    print(fname)
    return None

for fname in get_all_files(SRC):
    new_fname = get_new_fname(fname)
    if not new_fname:
        continue
    new_path = os.path.join(DST, new_fname)
    if not os.path.exists( os.path.dirname(new_path)):
        os.makedirs(os.path.dirname(new_path))
    shutil.copy(fname, new_path)



