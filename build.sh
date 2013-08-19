#!/bin/bash
# Copyright (c) 2013, Cai Guanhao (Choi Goon-ho)
# All rights reserved.

set -e

CURRENT="$(pwd)"
CONFIGS="$(pwd)/configs"
SITES="$(pwd)/sites"
SOURCE="$(pwd)/source"
CONCURRENT=0

GIT=$(which git)

if [[ ${#GIT} -eq 0 ]]; then
    echo "Install git first."
    exit 1
fi

echo "Updating $CURRENT ..."
cd "$CURRENT" && $GIT fetch --all
cd "$CURRENT" && $GIT reset --hard origin/master

if [[ ! -d "$SOURCE" ]]; then
    mkdir "$SOURCE"
fi

echo "Updating $SOURCE ..."
if [[ ! -d "$SOURCE/.git" ]]; then
    $GIT clone git://github.com/qnn/template.git "$SOURCE"
else
    cd "$SOURCE" && $GIT fetch --all
    cd "$SOURCE" && $GIT reset --hard origin/master
fi

JEKYLL=$(which jekyll)

if [[ ${#JEKYLL} -eq 0 ]]; then
    echo "Install jekyll first."
    exit 1
fi

if [[ ! -d $CONFIGS ]]; then
    echo "$CONFIGS: No such directory."
    exit
fi
if [[ ! -d $SOURCE ]]; then
    echo "$SOURCE: No such directory. Deploy first."
    exit
fi
if [[ ! -d $SITES ]]; then
    mkdir "$SITES"
fi

cd "$CURRENT"

if [[ ${#@} -eq 0 ]]; then
  echo "Please specify which sites (separated by spaces) to build or --all to build all sites."
  exit 1
elif [[ ${#@} -eq 1 ]] && [[ $1 == "--all" ]]; then
    OLD_IFS=$IFS
    IFS=$'\n'
    TODOS=($(ls -1 $CONFIGS | sed 's/.yml$//'))
    IFS=$OLD_IFS
    CONCURRENT=5
else
    TODOS=($@)
fi

LENGTH=${#TODOS[@]}

if [[ LENGTH -eq 0 ]]; then
    echo "File is empty."
    exit
fi

for TODO in "${TODOS[@]}"
do
    if [[ ! -f "$CONFIGS/$TODO.yml" ]]; then
        echo "At least this config does not exist: $TODO.yml"
        exit
    fi
done

handle_sigint() {
    set +e
    for job in `jobs -p`
    do
        kill -9 $job >/dev/null 2>&1
    done
    set -e
    echo
    echo "Aborted by user. Goodbye!"
    exit
}

trap handle_sigint SIGINT

if [[ LENGTH -le 3 ]]; then
    CONCURRENT=LENGTH
elif [[ CONCURRENT -eq 0 ]]; then
    echo "How many sites to build concurrently? [default=3, max=10, min=1]"
    read CONCURRENT;

    if [[ ! $CONCURRENT -ge 1 ]] || [[ ! $CONCURRENT -le 10 ]]; then
        CONCURRENT=3
    fi
fi

# http://stackoverflow.com/a/1685440/855665
bgxupdate() {
    bgxoldgrp=${bgxgrp}
    bgxgrp=""
    bgxcount=0
    bgxjobs=" $(jobs -pr | tr '\n' ' ')"
    for bgxpid in ${bgxoldgrp} ; do
        set +e
        echo "${bgxjobs}" | grep " ${bgxpid} " >/dev/null 2>&1
        if [[ $? -eq 0 ]] ; then
            bgxgrp="${bgxgrp} ${bgxpid}"
            (( bgxcount = bgxcount + 1 ))
        fi
        set -e
    done
}

bgxlimit() {
    bgxmax=$1 ; shift
    bgxupdate
    while [[ ${bgxcount} -ge ${bgxmax} ]] ; do
        sleep 1
        bgxupdate
    done
    if [[ "$1" != "-" ]] ; then
        $* &
        bgxgrp="${bgxgrp} $!"
    fi
}

jobsgroup=""
for TODO in "${TODOS[@]}"
do
    bgxgrp=${jobsgroup} ; \
    bgxlimit $CONCURRENT \
    $JEKYLL build --source "$SOURCE" --destination "$SITES/$TODO" \
        --config "$SOURCE/_config.yml","$CONFIGS/$TODO.yml" ; \
    jobsgroup=${bgxgrp}
    echo 'ACTIVE JOBS: [' ${jobsgroup} ']'
done

bgxgrp=${jobsgroup} ; bgxupdate ; jobsgroup=${bgxgrp}
while [[ ${bgxcount} -ne 0 ]] ; do
    oldcount=${bgxcount}
    while [[ ${oldcount} -eq ${bgxcount} ]] ; do
        sleep 1
        bgxgrp=${jobsgroup} ; bgxupdate ; jobsgroup=${bgxgrp}
    done
    echo 'ACTIVE JOBS: [' ${jobsgroup} ']'
done

echo "Done."
