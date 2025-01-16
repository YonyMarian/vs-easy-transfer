#!/bin/bash


# Opens WinSCP and transfers files
function transfer_to_winscp() { # <username> <password> <directory_name>
	if [[ "$#" -ne 3 ]]; then
		echo "Bad arguments passed to open_winscp()"
		return
	local username="$1"
	local password="$2"
	local dirname="$3"
	local hostname="${CLASS}.${URL_TAIL}" # from env_vars.txt
	local remote_path="${REMOTE_PATH_PREFIX}" # from env_vars.txt
	local sftp_connection="$username:$password@$hostname"

	# create WinSCP temp script to open with
	local winscp_script=$(mktemp)
	echo "open sftp://${connection}" >> "${winscp_script}"
	echo "option batch on" >> "${winscp_script}"
	echo "option confirm off" >> "${winscp_script}"
	echo "synchronize remote ./${dir_name} ${remote_path}${dir_name}" >> "${winscp_script}"
	echo "exit" >> "${winscp_script}"

	# execute the script in WinSCP
	echo "Opening WinSCP and syncing files..."
	winscp.com /script="$winscp_script"
	echo "The remote directory is now up-to-date."
	rm -f "$winscp_script"
}

# Main logic
function main() {
	# check for correct args
	if [[ "$#" -ne 1 ]]; then
		echo "usage: wcsp <directory_name>"
		return
	fi
	local dir_name="$1"
	if [[ ! -d "$1" ]]; then
		echo -e "Could not find directory: \'${1}\'"
		return
	fi
	# prompt for username
	local dir_name="$1"
	read -p "Enter username: " username
	if [[ ! "$username" ]]; then
		echo "You must enter a username."
		return
	fi
	# prompt for password
	read -p -s "Enter password: " password
	if [[ ! "$password" ]]; then
		echo "You must enter a password."
	# source constants, if found
	source env_vars.txt || return
	echo "Using constants in env_vars.txt."
	echo "Preparing to open WinSCP..."
	transfer_to_winscp "$username" "$password" "$dir_name"
}
