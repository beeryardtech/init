#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Fetches source code from varies repos and puts them in
dir defined by `$repos`

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

##
# Values
##
REPOS=~/repos

get_vim()
{
    local repo=$1
    local dry=$2
    local url="https://vim.googlecode.com/hg/"

    if [[ $dry ]] ; then
        [[ -d "$repo" ]] && exists=true || exists=false
        echo "Clone from url: $url"
        echo "Clone to dir: $repo"
        echo "Vim dir exists: $exists"
        return
    fi

    if [[ ! -d "$repo" ]] ; then
        hg clone "$url" "$repo"
        err=$?
        die $err "Failed to clone vim!"
    else
        echo "Directory exists. Not cloning."
    fi

    # Update code
    pushd "$repo"

    # Pull repo
    hg pull
    err=$?
    die $err "Failed to pull vim repo!"

    # Run update
    hg update
    err=$?
    die $err "Failed to update vim repo!"

    popd
}

get_ike()
{
    local repo=$1
    local dry=$2
    local url="https://www.shrew.net/download/ike/ike-2.2.1-release.tgz"

    if [[ $dry ]] ; then
        [[ -d "$repo" ]] && exists=true || exists=false
        echo "Fetch from url: $url"
        echo "IKE dir exists: $exists"
        return
    fi

    # Delete repo directory first
    rm -rf "$repo"

    $CURRENT_DIR/../helpers/gettar.sh "$url" "$repo"
    err=$?
    die $err "Failed to get IKE!"
}

main()
{
    get_vim "$REPOS/vim" $dryrun
    get_ike "$REPOS/ike" $dryrun
}
main
