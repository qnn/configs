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

echo -n "File to save: "

read SAVE

if [[ ! -f $SAVE ]]; then
	touch $SAVE >/dev/null 2>&1
	if [[ ! $? -eq 0 ]]; then
		echo "Unable to write to this file."
		exit
	fi
else
	if [[ ! -w $SAVE ]]; then
		echo "Unable to write to this file."
		exit
	fi
	echo -n "File exists. Overwrite? [Y/n] "
	while true; do
		read OVERWRITE
		case $OVERWRITE in
			[Yy]* )
				echo -n > $SAVE
				break;;
			[Nn]* )
				echo "Nothing has changed."
				exit;;
		esac
	done
fi

for WEBSITE in "${WEBSITES[@]}"; do

	cat >>$SAVE <<DATA

server {
	server_name ${WEBSITE};
	location / { rewrite ^ http://www.${WEBSITE}$request_uri? permanent; }
}
server {
	server_name www.${WEBSITE};
	root /srv/qnn-agent-sites/sites/${WEBSITE};
	index index.html;
}

DATA

done

echo "Done."
