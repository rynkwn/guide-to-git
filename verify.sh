# Use:
# sh verify.sh 1

BASE_COMMIT="b9cee4eda1258"

function num_commits_difference_since_base() {
	git log ${BASE_COMMIT}..HEAD --pretty=oneline | wc -l
}

function num_added_files_since_base() {
	raw_output=$(git diff ${BASE_COMMIT} --stat | wc -l)
	echo "$(($raw_output-1))"
}

# Returns -> Success/Error Message.
function verify () {
	# Perform a git check, git status, e.t.c.
	# Read that into a file.
	# Compare that with another file
	# Return if they're identical.
	LEVEL=$1

	echo; echo;
	if [ ${LEVEL} -eq "1" ]; then
		echo Checking level 1...

		if [ $(num_added_files_since_base) -ge "1" ]; then
			echo  \[C\] Add and commit at least one file!
		else
			echo  \[ \] Add and commit at least one file!
		fi

		if [ $(num_commits_difference_since_base) -ge "3" ]; then
			echo  \[C\] Create at least 2 more commits.
		else
			echo  \[ \] Create at least 2 more commits.
		fi
	else
		echo; echo _________________________________________
		echo; echo This isn\'t done yet, sorry!
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

# ttest=$(num_commits_difference_since_base)
# ttest2=$(num_added_files_since_base)
# echo ${ttest}
# echo ${ttest2}
