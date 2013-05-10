#!/bin/bash

WEBSITES=($(cat "$(pwd)/WEBSITES"))

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
