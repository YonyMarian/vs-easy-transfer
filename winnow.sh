#!/bin/bash

### CONSTANTS ###
readonly USAGE_GUIDELINES="Usage: winnow <source> <file extension(s)> <target>"

# automatically copy desired file types to specified folder
# Usage: winnow <source> <file extensions>... <destination>
function winnow() {
	# must be at least one source, one file ext, one target
	if [[ "$#" -lt 3 ]]; then
		echo "${USAGE_GUIDELINES}"
		return;
	fi

	# set local variables
	local source="$1"
	local target="${@: -1}"
	# check that the directories exist
	if [[ ! -d "${source}" ]] || [[ ! -d "${directory}" ]]; then
		echo "Could not find one or both of the directories."
		return;
	fi
	local num_exts=$(( $#-2 )) # the number of extensions, i.e., the middle ones
	# copy files
	for file_ext in ${@:2:num_exts}
	do
		echo "Attempting to copy ${file_ext} files..."
		cp -t "${target}/" "${source}/"*"${file_ext}" || echo -e "\tNo ${file_ext} files found in ${source}"
	done
	echo -e "Copied available requested filetypes to ${target}"
	read -p "Would you like to add ${target} to git? [y/n] : " git_ans
	case "$git_ans" in
		"y")
			git add "${target}"
			git status ;;
		"n")
			echo "Git will not track these changes." ;;
		*)
			echo "Did not detect valid input. Nothing was added to git." ;;
	esac
}

winnow "$@"
