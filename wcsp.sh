#!/bin/bash

# sources constants
function build_ip() {



# Opens WinSCP and transfers files
function open_winscp() {
	if [[ "$#" -ne 3 ]]; then
		echo "Bad arguments passed to open_winscp()"
		return
	local hostname = "$1"
	local username = "$2"
	local password = "$3"
}

# Main logic
function main() {
	# check for correct args
	if [[ "$#" -ne 1 ]]; then
		echo "usage: wcsp <directory_name>"
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
}
