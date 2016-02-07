#!/bin/sh

print_usage() {
    echo "Usage: $0 FILE"
}

process_args() {
    if [ $# -ne 1 ]
    then
	echo "ERROR"
	print_usage
	exit 1
    fi
}

calc_checksum() {
    md5sum "$1"
}

main() {
    process_args "$@"
    calc_checksum "$1"
}

main "$@"
