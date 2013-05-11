#!/bin/bash

SITELIST=(
	$(find "`pwd`" -maxdepth 1 -type f -regex '.*TODO.*')
	$(find "`pwd`" -maxdepth 1 -type f -regex '.*WEBSITES.*')
)

echo "Found ${#SITELIST[@]} files. Which one to use?"

NO=0;
for SITE in "${SITELIST[@]}"
do
	echo "  $NO) ${SITE##*/}"
	((NO++))
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

CONFIGS="$(pwd)/configs"

if [[ ! -d $CONFIGS ]]; then
	mkdir "$CONFIGS"
fi

for SITE in "${WEBSITES[@]}"
do
	if [[ ! -d "$CONFIGS/$SITE" ]]; then
		mkdir "$CONFIGS/$SITE"
		echo "$CONFIGS/$SITE created"
	fi
	if [[ ! -f "$CONFIGS/$SITE/_config.yml" ]]; then
		# clone config file
		cp "$(pwd)/sample_config.yml" "$CONFIGS/$SITE/_config.yml"
		
		if [[ ! -f "$CONFIGS/$SITE/_config.yml" ]]; then
			echo "$CONFIGS/$SITE/_config.yml is NOT OK."
			exit
		fi
		
		# replace url in config file
		sed -i.bak "s/url: http:\/\/www\.qnn\.com\.cn/url: http:\/\/www\.$SITE/g" "$CONFIGS/$SITE/_config.yml"
		rm -f "$CONFIGS/$SITE/_config.yml.bak"
		
		if [[ -f "$CONFIGS/$SITE/_config.yml" ]]; then
			echo "$CONFIGS/$SITE/_config.yml is OK."
		else
			echo "$CONFIGS/$SITE/_config.yml is NOT OK."
			exit
		fi
	fi
done

echo "Done."
