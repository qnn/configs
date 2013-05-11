#!/bin/bash

set -e

SITES="$(pwd)/sites"

GIT=$(which git)

if [[ ! -d $SITES ]]; then
	mkdir $SITES
fi

OLD_IFS=$IFS
IFS=$'\n'
WEBSITES=($(cat "$(pwd)/WEBSITES"))
IFS=$OLD_IFS

for WEBSITE in "${WEBSITES[@]}"
do

	if [[ ! -d "$SITES/$WEBSITE" ]]; then
		mkdir "$SITES/$WEBSITE"
	fi
	
	if [[ ! -d "$SITES/$WEBSITE/.git" ]]; then
		cd "$SITES/$WEBSITE" && $GIT clone git://github.com/qnn/template.git "$SITES/$WEBSITE" &
	else
		cd "$SITES/$WEBSITE" && $GIT pull origin master &
	fi

done

wait
