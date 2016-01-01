#!/bin/bash
#Sample script showing how to use muprint to generate paths and use those paths
#To sort music. This version uses copy instead of move for safety
#Run from the project root or change ./muprint to be approriate

#TODO: make these arguments
SRC_DIR="$1"
DST_DIR="$2"


handle_file() {
    # scratch file to use when transcoding
    local TMPFILE='/tmp/scratch'
    # $1 - file to move
    local file="$1"
    # $2 - where to move it
    local dest_root="$2"
    #extension to set if fixing containers
    local EXT=""

    #fix some of my fucked up containers so mimedb will work properly
    if [[ $file =~ \.ogg ]]; then
        #need to convert to an ogg audio container
        rm -f "$TMPFILE"
        ffmpeg -i "$file" -acodec copy -f oga "$TMPFILE" -hide_banner -loglevel fatal
        file="$TMPFILE"
        EXT='ogg'
    elif [[ $file =~ \.mp4 ]]; then
        #need to convert to an m4a containter
        rm -f "TMPFILE"
        ffmpeg -i "$file" -acodec copy -f ipod "$TMPFILE" -hide_banner -loglevel fatal
        file="$TMPFILE"
        ext='m4a'
    fi

    local dst="$(muprint -s 'A%ua' -s 't%uf' -r _ "$dest_root/%uA/%ub/%ut.%ue$EXT" "$file")"
    #debug echo
    #echo "$dst"
    mkdir -p "$(dirname "$dst")"
    cp "$file" "$dst"

    #cleanup
    rm -f "$TMPFILE"
}

#make move_file available to subshells
export -f handle_file

find "$SRC_DIR" -type f -exec sh -c 'handle_file "$1" "$2"' _ {} "$DST_DIR" \; 
