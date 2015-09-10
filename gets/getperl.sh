#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets any external PERL libraries.

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

###
# Values
###
INSTALLS="$CURRENT_DIR/../files/perl_installs.txt"
REMOVES="$CURRENT_DIR/../files/perl_removes.txt"

get_libs()
{
    local dry=$1
    if [[ $dry ]] ; then
        echo "Will install these modules."
        echo
        echo "Perl: $(< ${INSTALLS} )"
        return
    fi

    sudo cpan -i $(< ${INSTALLS} )
    err=$?
    die $err "Failed to install CPAN modules!"
}

main()
{
    get_libs $dryrun
}
main
