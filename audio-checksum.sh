#!/bin/sh

clear_tags() {
    local tmp="$1"
    operon clear -a "$tmp"
    operon image-clear "$tmp"
}

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
    calc_checksum "$1"
}

main "$@"
