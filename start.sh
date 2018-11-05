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
	git fetch origin master
	git reset --hard origin/master
	git branch | grep -v "master" | xargs git branch -D 
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
		git checkout -b test_branch >> /dev/null 2>&1
		echo "Try merging me!" >> tmp.txt
		git add -A >> /dev/null 2>&1 && git commit -m "Committed a file" >> /dev/null 2>&1
		git checkout master >> /dev/null 2>&1
	fi

	if [ ${LEVEL} -eq "4" ]; then
		# For level 4, we need to add a file to master.
		# Then create another file on another branch that'll conflict.
		echo "I'm the original!" >> tmp.txt
		git add -A >> /dev/null 2>&1 && git commit -m "I added a file" >> /dev/null 2>&1
		git checkout -b test_branch >> /dev/null 2>&1
		echo "No, I'm the original!" >> tmp.txt
		git add -A >> /dev/null 2>&1 && git commit -m "I also added a file. Also, secret code guidetogitwashere" >> /dev/null 2>&1
		git checkout master >> /dev/null 2>&1
		echo "Here's some more work!" >> tmp.txt
		git add -A >> /dev/null 2>&1 && git commit -m "I added another file" >> /dev/null 2>&1
	fi
}

clear
if [ $# -eq 0 ]; then
	printf "%s" "$(<${DIR}/res/raws/start.txt)"
else
	start_level $1
fi