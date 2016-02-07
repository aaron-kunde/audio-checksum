#!/bin/sh

print_usage() {
    echo "Usage: $0 FILE"
}

main() {
    if [ $# -ne 1 ]
    then
	echo "ERROR"
	print_usage
	exit 1
    fi
}

main "$@"
