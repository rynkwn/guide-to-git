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
	# git checkout master
	# git reset --hard 0d1d7fc32
	# git branch | grep -v "master" | xargs git branch -D 
	clear
}

# Use:
# sh level.sh 1
function start_level () {
	cleanup
	LEVEL=$1

	if [ -e ${DIR}/\_pages/${LEVEL}.md ]; then
		echo Visit this page for clearer instructions: 
		echo https://rynkwn.github.io/guide-to-git/levels/${LEVEL}/
		echo ____________________________________

		echo; echo;

		egrep -v '^(---)|(permalink.*)' ${DIR}/\_pages/${LEVEL}.md
		echo; echo;
	else
		echo; echo;
		echo Sorry, I don\'t recognize ${LEVEL}.
		echo;
		echo Add _just_ the number to start a level!
		echo Example: sh start.sh 1
		echo; echo;
	fi

	if [ ${LEVEL} -eq "3" ]; then
		# For level 3, we need to create a random file.
		git checkout -b test_branch
		echo "Try merging me!" >> tmp.txt
		git commit -am "Committed a file"
		git checkout master
	fi
}

clear
if [ $# -eq 0 ]; then
	printf "%s" "$(<${DIR}/res/raws/start.txt)"
else
	start_level $1
fi