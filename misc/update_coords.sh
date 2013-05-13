#!/bin/bash

set -e

CONFIGS=$(cd ../configs && pwd)

ALL_CONFIGS=($(find $CONFIGS -name "_config.yml"))

if [[ ${#ALL_CONFIGS[@]} -lt 1 ]]; then
	echo "No config files."
	exit
else
	echo "Found ${#ALL_CONFIGS[@]} config files in ${CONFIGS}."
fi

BASH=$(which bash)

XARGS=$(which xargs)

PRINT()
{
	let COL=$(tput cols)-${#1}
	printf "%s%${COL}s\n" "$1" "[$2]"
}

IS_FORCE=0
for arg in "$@"
do
	case "$arg" in
		--force)
			IS_FORCE=1
			;;
	esac
done

for CONFIG in "${ALL_CONFIGS[@]}"
do
	ADDR=$(grep '^addr: 地址：' $CONFIG |
		   sed 's/addr: 地址：\(.*\)/\1/' |
		   sed 's/\(.*\)[(（].*[)）]/\1/')
	if [[ ${#ADDR} -gt 5 ]]; then
		PRINT "${CONFIG}" "PROCESSING"
		if [[ $IS_FORCE -eq 0 ]] && 
			grep --quiet '^coord:.* # auto-updated' $CONFIG
		then
			printf "\e[1A"
			PRINT "${CONFIG}" "PASS"
			continue
		fi
		COORD=$($BASH $(find "`pwd`" -name "addr2geo.sh") ${ADDR} |
			    $XARGS $BASH $(find "`pwd`" -name "geo2point.sh") |
			    $XARGS $BASH $(find "`pwd`" -name "point2coord.sh"))
		printf "\e[1A"
		if [[ $COORD =~ ^[0-9]+\.[0-9]+,\ [0-9]+\.[0-9]+$ ]]; then
			sed -i.bak "s/coord: .*/coord: ${COORD} # auto-updated/g" "$CONFIG"
			rm -f "$CONFIG.bak"
			PRINT "${CONFIG}" "DONE"
		else
			PRINT "${CONFIG}" "FAILED"
			exit
		fi
	fi
done
