#!/bin/bash

# don't forget to define your constants! See the README.md for more details.

# Opens WinSCP and transfers files
function transfer_to_winscp() { # <username> <password> <directory_name>
	if [[ "$#" -ne 3 ]]; then
		echo "Bad arguments passed to transfer_to_winscp()."
		return;
	fi
	local username="$1"
	local password="$2"
	local dir_name="$3"
	local hostname="${CLASS}.${URL}"
	local remote_path="${REMOTE_PATH_PREFIX}${CLASS}/"
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

# opens PuTTY terminal to desired directory
function open_putty() {
	# check for correct args
	if [[ "$#" -ne 3 ]]; then
		echo "Bad arguments passed to open_putty()."
		return;
	fi
	local username="$1"
	local password="$2"
	local hostname="${CLASS}.${URL}"
	local dir_name="$3"
	local dir_path="${REMOTE_PATH_PREFIX}${CLASS}/${dir_name}/"
	plink -t -batch "${username}@${hostname}" -pw "${password}" "cd ${dir_path} && export PS1='[${username}@${hostname}] (plink)$ ' && bash"
	echo -e "Remote connection terminated.\n"
}

# Main logic
function main() {
	# check for correct args
	if [[ "$#" -ne 1 ]]; then
		echo "Usage: wcsp <directory_name>"
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

	# transfer files to WinSCP
	transfer_to_winscp "${username}" "${password}" "${dir_name}"

	# open PuTTY, if desired
	printf "Would you like to open ${remote_path}${dir_name} in PuTTY? [y/n]: "
	read -r putty_ans
	case "$putty_ans" in
		"y")
			echo "Opening PuTTY terminal..."
			open_putty "${username}" "${password}" "${remote_path}${dir_name}" ;;
		"n")
			echo "PuTTY terminal will not open." ;;
		*)
			echo "Invalid input. Terminating..." ;;
	esac
	echo "All processes complete."
}

main "$@"

