#!/bin/bash
# Copyright (c) 2013, Cai Guanhao (Choi Goon-ho)
# All rights reserved.

set -e

CURRENT="$(pwd)"
CONFIGS="$(pwd)/configs"
SITES="$(pwd)/sites"
SOURCE="$(pwd)/source"

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
    SITELIST=(
        $(find "`pwd`" -maxdepth 1 -type f -regex '.*TODO.*')
        $(find "`pwd`" -maxdepth 1 -type f -regex '.*WEBSITES.*')
    )

    echo "Found ${#SITELIST[@]} list files."
    echo "Select one to read or enter site domain names (separated by spaces):"

    NO=0;
    for SITE in "${SITELIST[@]}"
    do
        echo "  $NO) ${SITE##*/}"
        (( NO = NO + 1 ))
    done

    read NO

    if [[ $NO =~ ^[0-9]+$ ]] && [[ $NO -ge 0 ]] && [[ $NO -lt ${#SITELIST[@]} ]]; then
        FILE=${SITELIST[$NO]}

        echo "Using $FILE."

        OLD_IFS=$IFS
        IFS=$'\n'
        TODOS=($(cat $FILE))
        IFS=$OLD_IFS
    else
        if [[ ${#NO} -gt 0 ]]; then
            OLD_IFS=$IFS
            IFS=$' '
            TODOS=($NO)
            IFS=$OLD_IFS
        else
            echo "No input file."
            exit
        fi
    fi
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
    if [[ ! -d "$CONFIGS/$TODO" ]]; then
        echo "At least this config does not exist: $TODO"
        exit
    fi
    if [[ ! -d "$SITES/$TODO" ]]; then
        mkdir "$SITES/$TODO"
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
else
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
        --config "$SOURCE/_config.yml","$CONFIGS/$TODO/_config.yml" ; \
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
