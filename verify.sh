# Use:
# sh verify.sh 1

BLACK='\033[0;30m'
GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'

BASE_COMMIT="b9cee4eda1258"

function num_commits_difference_since_base() {
	git log ${BASE_COMMIT}..HEAD --pretty=oneline | wc -l
}

function num_added_files_since_base() {
	raw_output=$(git diff ${BASE_COMMIT} --stat | wc -l)
	echo "$(($raw_output-1))"
}

function num_branches() {
	git branch | wc -l
}

function num_commit_difference_between_branches() {
	if [ $(git branch | wc -l) -ge "2" ]; then
		second_branch=$(git branch | sed -n 2p | tr -s " " "\012" | sed -n 2p)
		echo "$(git rev-list --count $second_branch ^master)"
	else
		echo '0'
	fi
}

function verify_level_3() {
	echo "$(git log -n 4 | grep "Committed a file" | wc -l)"
}

function verify_level_4() {
	# We check in this case if we get 0, rather than 1. Just to make things simpler.
	file_exists=$( (ls tmp.txt >> /dev/null 2>&1 && echo "0") || echo "1" )
	if [ $file_exists -eq "0" ]; then
		# There's an edge case where they actually need to merge... and I'm not
		# sure if there's an easy way to check it.
		echo "$(grep "HEAD" tmp.txt | wc -l)"
	else
		echo "1"
	fi
}

# Returns -> Success/Error Message.
function verify () {
	# Perform a git check, git status, e.t.c.
	# Read that into a file.
	# Compare that with another file
	# Return if they're identical.
	LEVEL=$1

	echo; echo;
	echo Checking level ${LEVEL}...; echo;
	if [ ${LEVEL} -eq "1" ]; then
		if [ $(num_added_files_since_base) -ge "1" ]; then
			echo  \[C\] Add and commit at least one file!
		else
			echo  \[ \] Add and commit at least one file!
		fi

		if [ $(num_commits_difference_since_base) -ge "2" ]; then
			echo  \[C\] Create at least 2 more commits.
		else
			echo  \[ \] Create at least 2 more commits.
		fi
	elif [ ${LEVEL} -eq "2" ]; then
		if [ $(num_branches) -ge "2" ]; then
			echo \[C\] Create another branch besides master
		else
			echo \[ \] Create another branch besides master
		fi
		 
		if [ $(num_commit_difference_between_branches) -ge "1" ]; then
			echo \[C\] Have a commit on that branch that\'s not on master
		else
			echo \[ \] Have a commit on that branch that\'s not on master
		fi
	elif [ ${LEVEL} -eq "3" ]; then
		if [ $(verify_level_3) -ge "1" ]; then
			echo \[C\] When you start this level, there\'ll be a new branch \(test_branch\). Merge that into master\!
		else
			echo \[ \] When you start this level, there\'ll be a new branch \(test_branch\). Merge that into master\!
		fi
	elif [ ${LEVEL} -eq "4" ]; then
		echo As a heads-up... it\s not easy to check 
		echo if you actually merged\! So be sure you do before trusting this\!
		echo; echo;

		if [ $(verify_level_4) -eq "0" ]; then
			echo \[C\] When you start this level, there\'ll be a new branch \(test_branch\) that\'ll have some conflicts. Merge that into master\!
		else
			echo \[ \] When you start this level, there\'ll be a new branch \(test_branch\) that\'ll have some conflicts. Merge that into master\!
		fi
	else
		echo; echo _________________________________________
		echo; echo Hmm. That doesn\t seem to be a level\! \(Right now, we have 1-4\).
		echo; echo _________________________________________
	fi
}

if [ $# -eq 0 ]; then
	echo;
	echo This command needs an argument!
	echo Try something like \`sh verify.sh 1\`
else
	verify $1
fi
