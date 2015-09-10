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
    local installs=$1
    local dry=$2

    if [[ $dry ]] ; then
        [[ -f "$installs" ]] && exists=true || exists=false
        echo "Installs exists: $exists"
        echo "Will install these modules."
        echo "Perl: $(< ${installs} )"
        return
    fi

    sudo cpan -i $(< ${installs} )
    err=$?
    die $err "Failed to install CPAN modules!"
}

main()
{
    get_libs $INSTALLS $dryrun
}
main
