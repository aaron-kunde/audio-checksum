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
    local audio="$1"
    local tmp="$audio.tmp"
    local masked_audio=$(echo "$audio" | sed -e 's/\//\\\//g')
    local masked_tmp=$(echo "$tmp" | sed -e 's/\//\\\//g')

    cp "$audio" "$tmp"

    md5sum "$tmp" | sed -e s/"$masked_tmp"/"$masked_audio"/

    rm "$tmp"
}

main() {
    process_args "$@"
    calc_checksum "$1"
}

main "$@"
