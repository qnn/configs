#!/bin/bash

set -e

GIT=$(which git)

CURRENT="$(pwd)"

echo "Updating $CURRENT ..."
cd "$CURRENT" && $GIT pull origin master

SOURCE="$(pwd)/source"

if [[ ! -d "$SOURCE" ]]; then
	mkdir "$SOURCE"
fi

echo "Updating $SOURCE ..."
if [[ ! -d "$SOURCE/.git" ]]; then
	$GIT clone git://github.com/qnn/template.git "$SOURCE"
else
	cd "$SOURCE" && $GIT pull origin master
fi

echo "Done."
