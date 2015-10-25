#!/bin/bash

mkdir -p "$2"
pushd "$1" > /dev/null

function isFlac {
    local TMP="$(mimedb -f $1 | grep -i flac)"
    [[ -n "$TMP" ]]
}

FF_COMMANDS=""
LN_COMMANDS=""

while IFS= read -r -d $'\0' line; do
    if [[ -d "$line" ]]; then
        mkdir -p "$2/$line"
    fi
    if [[ -f "$line" ]]; then
        if isFlac "$line" ; then
            OUT=$2/$(echo $line | sed s/.flac/.ogg/I)
            if [ ! -e "$OUT" ] ; then
                FF_COMMANDS="$FF_COMMANDS ffmpeg -loglevel quiet -y -i \"$line\" -acodec libvorbis \"$OUT\"\n"
            fi
        else
            OUT="$2/$line"
            if [ ! -e "$OUT" ] ; then
                LN_COMMANDS="$LN_COMMANDS ln -s \"$1/$line\" \"$2/$line\"\n"
            fi
        fi
    fi
done < <(find . -print0)

echo "Starting up, found $(echo -e $FF_COMMANDS | wc -l) flac files"
echo "Found $(echo -e $LN_COMMANDS | wc -l) files to link"
COMMANDS="$FF_COMMANDS $LN_COMMANDS"
echo -e $COMMANDS | parallel --bar 

popd > /dev/null
