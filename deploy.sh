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

COUNT=1
LENGTH=${#WEBSITES[@]}

for WEBSITE in "${WEBSITES[@]}"
do

	echo "Processing $WEBSITE ($COUNT out of $LENGTH) ..."
	
	if [[ ! -d "$SITES/$WEBSITE" ]]; then
		mkdir "$SITES/$WEBSITE"
	fi
	
	cd "$SITES/$WEBSITE"
	
	if [[ ! -d "$SITES/$WEBSITE/.git" ]]; then
		$GIT clone git://github.com/qnn/template.git "$SITES/$WEBSITE"
	else
		$GIT pull origin master
	fi
	
	COUNT=$[COUNT+1]
	
	sleep 1
	
	echo

done
