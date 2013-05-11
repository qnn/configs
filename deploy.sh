#!/bin/bash

set -e

SITES="$(pwd)/sites"

GIT=$(which git)

if [[ ! -d $SITES ]]; then
	mkdir $SITES
fi

SITELIST=(
	$(find "`pwd`" -maxdepth 1 -type f -regex '.*TODO.*')
	$(find "`pwd`" -maxdepth 1 -type f -regex '.*WEBSITES.*')
)

echo "Found ${#SITELIST[@]} files. Which one to use?"

NO=0;
for SITE in "${SITELIST[@]}"
do
	echo "  $NO) ${SITE##*/}"
	(( NO = NO + 1 ))
done

read NO

if [[ $NO =~ ^[0-9]+$ ]] && [[ $NO -ge 0 ]] && [[ $NO -lt ${#SITELIST[@]} ]]; then
	FILE=${SITELIST[$NO]}
else
	echo "No input file."
	exit
fi

echo "Using $FILE."

OLD_IFS=$IFS
IFS=$'\n'
WEBSITES=($(cat $FILE))
IFS=$OLD_IFS

LENGTH=${#WEBSITES[@]}

if [[ LENGTH -eq 0 ]]; then
	echo "File is empty."
	exit
fi

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

echo "Done."
