#!/bin/bash

### CONSTANTS ###
USAGE_GUIDELINES = "Usage: winnow <source> <file extension(s)> <target>"

# automatically copy desired file types to specified folder
# Usage: winnow <source> <file extensions>... <destination>
function winnow() {
	# must be at least one source, one file ext, one target
	if [[ "$#" -lt 3 ]]; then
		echo "${USAGE_GUIDELINES}"
		return
	fi


