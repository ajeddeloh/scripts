pushd /media/Music > /dev/null
find . -type d -exec mkdir -p /media/MusicLossy/{} \;
popd > /dev/null
#oh god why
find /media/Music -type f -name "*.flac" -print0 | xargs -P7 -I '{}' -0 \
    bash -c 'echo "$1" && ffmpeg -hide_banner -loglevel quiet -n -i "$1"  -acodec libvorbis "$(echo "$1" | sed s/^\\\/media\\\/Music/\\\/media\\\/MusicLossy/ | sed s/\.flac/\.ogg/)"' - '{}'
find /media/Music -type f ! -name "*.flac" -print0 | xargs -P0 -I '{}' -0 \
    bash -c 'ln "$1" "$(echo "$1" | sed s/^\\\/media\\\/Music/\\\/media\\\/MusicLossy/)"' - '{}' \;

