#!/bin/sh

BLACK='\033[0;30m'
GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'

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

	if [ ${LEVEL} -eq "1" ]; then
		echo
	fi

	cat ${DIR}/res/raws/${LEVEL}.txt
	echo; echo;
}

clear
if [ $# -eq 0 ]; then
	printf "%s" "$(<${DIR}/res/raws/start.txt)"
else
	start_level $1
fi