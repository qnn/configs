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

QUIET="--quiet"

for arg in "$@"
do
	case "$arg" in
	--no-quiet)
		QUIET=""
		;;
	esac
done

for WEBSITE in "${WEBSITES[@]}"
do

	if [[ ! -d "$SITES/$WEBSITE" ]]; then
		mkdir "$SITES/$WEBSITE"
	fi
	
	if [[ ! -d "$SITES/$WEBSITE/.git" ]]; then
		cd "$SITES/$WEBSITE" &&
		$GIT clone $QUIET git://github.com/qnn/template.git "$SITES/$WEBSITE" &&
		echo "$WEBSITE is OK." &
	else
		cd "$SITES/$WEBSITE" &&
		$GIT pull $QUIET origin master &&
		echo "$WEBSITE is already up-to-date." &
	fi

done

wait
