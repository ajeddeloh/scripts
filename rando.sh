#!/bin/bash
NLINES="$(wc -l /usr/share/dict/cracklib-small | awk '{printf $1}')"
echo $NLINES
while true
do
    N=$RANDOM
    let "N %= $NLINES"
    echo $N
    sed "$N q;d" /usr/share/dict/cracklib-small | espeak
done
