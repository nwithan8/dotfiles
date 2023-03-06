#!/usr/bin/env bash

# Find files with EXTS, reformat and rsync with new name
#
# Ex:
# Godzilla.King.of.the.Monsters.2019.1080p.Blu-Ray.Evvt[1337x].mkv ->
# Godzilla King of the Monsters (2019).mkv
#
# Files without periods are unaffected by change, will be moved properly
# Ex.
# Of Mice and Men (1992).mkv -> Of Mice and Men (1992).mkv
#
#
# Script effectively grabs all files from the SRC with one of the EXTS, joins name segments (words separated by .) up to and including the year (excluding anything after the year, often quality, source and other tags), then rsync the file (recursively, with progress, deletes source file upon completion) to the DEST folder

SRC=$1
DEST=$2
re='^[0-9]+$'
EXTS=['mkv','mp4']

if [[ $# > 1 ]]; then
    if [ $(echo ${SRC: -1}) == "/" ]; then
        SRC=${SRC::-1}
    fi
    if [ $(echo ${DEST: -1}) == "/" ]; then
        DEST=${DEST::-1}
    fi
    for f in $SRC/*; do
    #for f in $(find $SRC -type f); do
        #echo $f
        #if [[ ${EXTS[*]} =~ $(echo ${f##*.}) ]]; then
        if [[ $(echo ${f##*.}) == 'mkv' || $(echo ${f##*.}) == 'mp4' ]]; then
            #echo $f
            f2=$(basename "$f")
            #echo $f2
            #echo $0
            if ! [[ $f2 == $0 ]]; then
                IFS='.' read -ra ADDR <<< "$f2"
                NAME=''
                for i in "${ADDR[@]}"; do
                    #echo $i
                    if [[ $i == 'mkv' || $i == 'mp4' ]]; then
                    #if [[ ${EXTS[*]} =~ $i ]]; then
                        break
                    elif ! [[ $i =~ $re ]]; then
                        #echo $i
                        NAME+="$i "
                    else
                        NAME+="($i)"
                        break
                    fi
                done
                NAME=$(echo $NAME | xargs)
                if ! [[ $(echo $NAME | tr '[:upper:]' '[:lower:]') =~ ^(sample|example|demo|preview) ]]; then
                    NAME=$(echo $NAME | xargs).$(echo ${f##*.})
                    #echo $NAME
                    #echo $(find $SRC -type f -name "$NAME")
                    echo Moving $NAME...
                    #echo $DEST/"$NAME"
                    #rsync -r --progress --remove-source-files "$f" "$DEST"/"$NAME"
                fi
            fi
        fi
    done
else
    echo "Error running movie mover.
Usage: "$0" SRC DEST"
fi
