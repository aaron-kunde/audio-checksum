#! /bin/sh

clean_tags() {
    local in_file="$1"
    local out_file="$2"
    local extension="${in_file##*.}"
    local tmp_in=$(dirname "$in_file")/audio.$extension

    cp "$in_file" "$tmp_in"
    
    operon clear -a "$tmp_in"
    operon image-clear "$tmp_in"

    mv "$tmp_in" "$out_file"
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
    which operon && process_args "$@"
}

main "$@"
