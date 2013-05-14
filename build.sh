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
TODOS=($(cat $FILE))
IFS=$OLD_IFS

LENGTH=${#TODOS[@]}

if [[ LENGTH -eq 0 ]]; then
	echo "File is empty."
	exit
fi

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

echo "Q: How many sites to build concurrently? [default=3, max=10, min=1]"
echo -n "A: "
read CONCURRENT;

if [[ ! $CONCURRENT -ge 1 ]] || [[ ! $CONCURRENT -le 10 ]]; then
	CONCURRENT=3
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
	$JEKYLL build --source "$SITES/$TODO" --destination "$SITES/$TODO/_site" \
		--config "$SITES/$TODO/_config.yml","$CONFIGS/$TODO/_config.yml" ; \
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
