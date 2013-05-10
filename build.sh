#!/bin/bash

set -e

CONFIGS="$(pwd)/configs"
SITES="$(pwd)/sites"

JEKYLL=$(which jekyll)

if [[ ! -d $CONFIGS ]]; then
	echo "$CONFIGS: No such directory."
	exit
fi
if [[ ! -d $SITES ]]; then
	echo "$SITES: No such directory."
	exit
fi

OLD_IFS=$IFS
IFS=$'\n'
TODOS=($(cat "$(pwd)/TODO"))
IFS=$OLD_IFS

COUNT=1
LENGTH=${#TODOS[@]}

if [[ LENGTH -eq 0 ]]; then
	echo "TODO is empty."
fi

for TODO in "${TODOS[@]}"
do

	echo "Processing $TODO ($COUNT out of $LENGTH) ..."
	
	if [[ ! -d "$SITES/$TODO" ]]; then
		echo "$SITES/$TODO: No such directory. Ignored."
	else
		$JEKYLL build --source "$SITES/$TODO" --destination "$SITES/$TODO/_site" --config "$CONFIGS/$TODO/_config.yml"
	fi
	
	COUNT=$[COUNT+1]
	
	echo

done
