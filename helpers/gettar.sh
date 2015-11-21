#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Fetch and unpack a tar file.

- Download tar with wget
- Untar the file

positional arguments:
url   The url for the file to get
dir   Target directory when unpacked

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo "$USAGE" ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

get_tar()
{
    local url="$1"
    local path="$2"
    local dry="$3"

    if [[ $dry ]] ; then
        echo "Url to file: $url"
        echo "Path to tar file: $path"
        return
    fi

    wget -O $path "$url"
    err=$?
    die $err "Failed to get file! Url: $url Path: $path"
}

unpack()
{
    local path="$1"
    local dir="$2"
    local dry="$3"

    if [[ $dry ]] ; then
        echo "Path to tar file: $path"
        echo "Output dir: $dir"
        return
    fi

    # Extract file to same dir as path
    # The `z` means uncompress it first
    tar -C "$dir" -xvzf "$path"
    err=$?
    die $err "Failed to untar file! Path: $path"
}

main()
{
    local url="$1"
    local dir="$2"
    local path=$( get_path_from_url "$url" )

    get_tar "$url" "$dir" $dryrun
    unpack "$path" "$dir" $dryrun
}
main $@
