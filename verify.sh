# Use:
# sh verify.sh 1

BASE_COMMIT="b9cee4eda1258"

function num_commits_difference_since_base() {
	git log ${BASE_COMMIT}..HEAD --pretty=oneline | wc -l
}

# Returns -> Success/Error Message.
function verify () {
	# Perform a git check, git status, e.t.c.
	# Read that into a file.
	# Compare that with another file
	# Return if they're identical.
	LEVEL=$1

	if [ ${LEVEL} -eq "1" ]; then
		echo
	fi

	echo; echo _________________________________________
	echo; echo This doesn\'t work yet! But congratulations!
	echo; echo _________________________________________
}

if [ $# -eq 0 ]; then
	echo;
	echo This command needs an argument!
	echo Try something like \`sh verify.sh 1\`
else
	verify $1
fi

# ttest=$(num_commits_difference_since_base)
# echo ${ttest}