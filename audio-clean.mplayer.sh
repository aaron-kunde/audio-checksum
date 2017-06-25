#! /bin/sh

clean_tags() {
    local in_file="$1"
    local out_file="$2"

    # MPlayer and FFMpeg cannot open files with brackets '[' in the filename.
    # Therefore we make a temporary copy of the audio file
    local tmp_in=$(dirname "$in_file")/audio.copy
    cp "$in_file" "$tmp_in"
    
    mplayer -really-quiet -noconsolecontrols -dumpaudio -dumpfile "$out_file" "$in_file"

    rm "$tmp_in"
}

print_usage() {
    echo "Usage: $0 IN OUT"
}

error() {
    local msg=$1
    local err_code=$2
    echo "ERROR: $msg"
    print_usage

    exit $err_code
}

process_args() {
    if [ $# -ne 2 ]; then
	error "Wrong number of arguments" 1
    fi
    clean_tags "$1" "$2"
}

main() {
    which mplayer && process_args "$@"
}

main "$@"
