#!/bin/bash
# Copyright (c) 2013, Cai Guanhao (Choi Goon-ho)
# All rights reserved.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ${#@} -eq 0 ]]; then
    OLD_IFS=$IFS
    IFS=$'\n'
    WEBSITES=($(ls -1 "$DIR/configs" | sed 's/.yml$//'))
    IFS=$OLD_IFS
else
    WEBSITES=($@)
fi

LENGTH=${#WEBSITES[@]}

if [[ LENGTH -eq 0 ]]; then
    echo "File is empty."
    exit 1
fi

for WEBSITE in "${WEBSITES[@]}"
do
    if [[ ! $WEBSITE =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$ ]]; then
        echo "At least '$WEBSITE' does not seem to be a valid domain name."
        exit
    fi
done

echo "${LENGTH} domain names are fine."

echo -n "File to save: "

read SAVE

if [[ ! -f $SAVE ]]; then
    touch $SAVE >/dev/null 2>&1
    if [[ ! $? -eq 0 ]]; then
        echo "Unable to write to this file."
        exit
    fi
else
    if [[ ! -w $SAVE ]]; then
        echo "Unable to write to this file."
        exit
    fi
    echo -n "File exists. Overwrite? [Y/n] "
    while true; do
        read OVERWRITE
        case $OVERWRITE in
            [Yy]* )
                echo -n > $SAVE
                break;;
            [Nn]* )
                echo "Nothing has changed."
                exit;;
        esac
    done
fi

for WEBSITE in "${WEBSITES[@]}"; do

    cat >>$SAVE <<DATA

server {
    server_name ${WEBSITE};
    location / { rewrite ^ http://www.${WEBSITE}\$request_uri? permanent; }
}
server {
    server_name www.${WEBSITE};
    root ${DIR}/sites/${WEBSITE};
    index index.html;
}

DATA

done

echo "Done."
