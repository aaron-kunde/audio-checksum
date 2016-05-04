#!/bin/sh

print_usage() {
    echo "Usage: $0 [-c|--check] FILE"
}

error() {
    local msg=$1
    local err_code=$2
    echo "ERROR: $msg"
    print_usage

    exit $err_code
}

process_args() {
    case $# in
	0)
	    error "Not enough arguments" 1
	    ;;
	1)
	    case $1 in
		"-c" | "--check")
		    error "Missing FILE arguments" 2
		    ;;
		*)
		    calc_checksum "$1"
		    ;;
	    esac
	    ;;
	2)
	    case $1 in
		"-c" | "--check")
		check_checksums "$2"
		;;
		*)
		    error "Unknown argument: $1" 3
		    ;;
	    esac
	    ;;
	*)
	    error "Too many arguments" 4
	    ;;
    esac
}

check_checksums() {
    local chksumfile="$1"
    local cnt_failures=0
    local cnt_missing=0
    local ret_code=0
    # Setting the internal field separator, only to split words by newlines in
    # for loop
    IFS=$'\n'
    # Lines starting with `#' are treated as comments and are not processed
    for f in $(grep -ve '^#.*' "$chksumfile" | cut -d '*' -f 2-)
    do
	if [ -f "$f" ]
	then
	    grep -qF "$(calc_checksum "$f")" "$chksumfile"
	    
	    if [ $? -eq 0 ]
	    then
		echo "$f: OK"
	    else
		((cnt_failures++))
		echo "$f: FAILED"
		ret_code=1
	    fi
	else
	    ((cnt_missing++))
	    echo "$0: $f: No such file or directory"
	    ret_code=1
	fi
    done
    if [ $cnt_missing -ne 0 ]
    then
	echo "$0: WARNING: $cnt_missing listed files could not be read"
    fi
    if [ $cnt_failures -ne 0 ]
    then
	echo "$0: WARNING: $cnt_failures computed checksum did NOT match"
    fi
    return $ret_code
}

calc_checksum() {
    local audio="$1"
    local tmp=$(dirname "$audio")/stream.dump
    "$(dirname $0)/audio-clean.sh" "$audio" "$tmp"

    if [ -f "$tmp" ]; then
	# Mask directory separators '/' for the sed script below and ampersand '&'
	# to avoid putting jobs into background
	local masked_audio=$(echo "$audio" | sed -e 's/\//\\\//g' | sed -e 's/&/\\&/g')
	local masked_tmp=$(echo "$tmp" | sed -e 's/\//\\\//g' | sed -e 's/&/\\&/g')

	md5sum "$tmp" | sed -e s/"$masked_tmp"/"$masked_audio"/

	rm "$tmp"
    else
	echo "WARNING: Could not process file '$audio'" > /dev/stderr
    fi
}

main() {
    process_args "$@"
}

main "$@"
