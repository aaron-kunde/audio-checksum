#!/bin/sh

clear_tags() {
    local tmp="$1"
    operon clear -a "$tmp"
    operon image-clear "$tmp"
}

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
    # Lines starting with `#' are treated as comments and are not processed
    grep -ve '^#.*' "$chksumfile" | cut -d '*' -f 2- | while read f
    do
	if [ -f "$f" ]
	then
	    grep -qF "$(calc_checksum "$f")" "$chksumfile"
	    
	    if [ $? -eq 0 ]
	    then
		echo "$f: OK"
	    else
		echo "$f: FAILED"
	    fi
	else
	    echo "$0: $f: No such file or directory"
	fi
    done
}

calc_checksum() {
    local audio="$1"
    # Preserve the file extension, since some tools need the right file
    # extension to work properly
    local audio_ext="${audio##**.}"
    local tmp="$audio.tmp.$audio_ext"
    # Mask directory separators '/' for the sed script below
    local masked_audio=$(echo "$audio" | sed -e 's/\//\\\//g')
    local masked_tmp=$(echo "$tmp" | sed -e 's/\//\\\//g')

    cp "$audio" "$tmp"

    clear_tags "$tmp"
    md5sum "$tmp" | sed -e s/"$masked_tmp"/"$masked_audio"/

    rm "$tmp"
}

main() {
    process_args "$@"
}

main "$@"
