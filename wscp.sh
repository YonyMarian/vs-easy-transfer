#!/bin/bash

# don't forget to define your constants! See the README.md for more details.

# Opens WinSCP and transfers files
function transfer_to_winscp() { # <username> <password> <directory_name>
	if [[ "$#" -ne 3 ]]; then
		echo "Bad arguments passed to transfer_to_winscp()"
		return;
	fi
	local username="$1"
	local password="$2"
	local dir_name="$3"
	local hostname="${HOSTNAME}"
	local remote_path="${REMOTE_PATH_PREFIX}"
	local sftp_connection="$username:$password@$hostname"

	# create WinSCP temp script to open with
	local winscp_script=$(mktemp)


# WinSCP script for transferring files
	cat <<EOF > "$winscp_script"
open sftp://"${sftp_connection}"
option batch on
option confirm off
mkdir "${remote_path}${dir_name}"
synchronize remote "${dir_name}" "${remote_path}${dir_name}"
exit
EOF

	# execute the script in WinSCP
	echo "Opening WinSCP and syncing files..."
	winscp.com -script="$winscp_script"
	echo "The remote directory is now up-to-date."
	rm -f "$winscp_script"
}

# Main logic
function main() {
	# check for correct args
	if [[ "$#" -ne 1 ]]; then
		echo "usage: wcsp <directory_name>"
		return;
	fi
	local dir_name="$1"
	if [[ ! -d "$1" ]]; then
		echo -e "Could not find directory: \'${1}\'"
		return;
	fi
	# prompt for username
	local dir_name="$1"
	printf "Enter username: "
	read -r username
	if [[ ! "$username" ]]; then
		echo "You must enter a username."
		return;
	fi
	# prompt for password
	printf "Enter password: "
	read -rs password
	if [[ ! "$password" ]]; then
		echo "You must enter a password."
		return;
	fi
	echo
	echo "Searching for constants in ~/.bashrc."
	source ~/.bashrc
	echo "Preparing to open WinSCP..."
	transfer_to_winscp "${username}" "${password}" "${dir_name}"
	echo "File transfer complete. Don't forget to close off any connections when you're done!"
}

main "$@"

