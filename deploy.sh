#!/bin/bash

set -e

SOURCE="$(pwd)/source"

GIT=$(which git)

if [[ ! -d "$SOURCE" ]]; then
	mkdir "$SOURCE"
fi

if [[ ! -d "$SOURCE/.git" ]]; then
	$GIT clone git://github.com/qnn/template.git "$SOURCE"
else
	cd "$SOURCE" && $GIT pull origin master
fi

echo "Done."
