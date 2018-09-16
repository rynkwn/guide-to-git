#!/bin/sh

clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

function cleanup () {
	# Cleanup the git directory of this file/folder.
	clear
	# git reset --hard 0d1d7fc32
}

# Use:
# sh level.sh 1
function start_level () {
	cleanup
	LEVEL=$1

	cat ${DIR}/res/raws/${LEVEL}.txt
	echo; echo;
}

if [ $# -eq 0 ]; then
	cat ${DIR}/res/raws/start.txt
else
	start_level $1
fi