#!/bin/bash

COMMANDS='/tmp/commands'

mkdir -p $2
pushd "$1"

find . -print0 | while IFS= read -r -d $'\0' line; do
    if [[ -d "$line" ]]; then
        mkdir -p "$2/$line"
    fi
    if [[ -f "$line" ]]; then
        TYPE="$(mimedb -f $line | grep -i flac)"
        if [[ -n "$TYPE" ]]; then
            OUT=$2/$(echo $line | sed s/.flac/.ogg/I)
            echo "ffmpeg -loglevel quiet -y -i \"$line\" -acodec libvorbis \"$OUT\"" >> $COMMANDS &
        else
            ln -s "$1/$line" "$2/$line"
        fi
    fi
done

PARALLEL=-j9 parallel --bar -a $COMMANDS

rm $COMMANDS
popd 
