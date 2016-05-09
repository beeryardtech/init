#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Builds Task Warrior (task package) from source code.

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
        h) echo -e "$USAGE" ; exit 255 ;;
        n) dryrun=true ;;
    esac
done

##
# Values
##
REPO=~/repos/task
CHECK_ARGS="${CURRENT_DIR}/../files/task_check_args.txt"
CONFIG_ARGS="${CURRENT_DIR}/../files/task_config_args.txt"

cmake_build()
{
    local arg_file=$1
    local dry=$2

    if [[ $dry ]] ; then
        local exists=
        [[ -f "$arg_file" ]] && exists=true || exists=false
        echo "Arg file: $arg_file"
        echo "Arg file exists: $exists"
        echo "Args: $(< ${arg_file} )"
        return
    fi

    cmake $(< ${arg_file} )
    err=$?
    die $err "Failed to config task! Arg file: $arg_file Args: $(< ${arg_file} )"
}

do_make()
{
    local dry=$1

    if [[ $dry ]] ; then
        echo "Args: $args"
        return
    fi

    make clean
    err=$?
    die $err "Make clean failed!"

    make
    err=$?
    die $err "Make failed! Args: $args"
}

do_install()
{
    local dry=$1

    sudo make install
    err=$?
    die $err "Make INSTALL failed!"
}

task_check()
{
    which task
    err=$?
    die $err "Install failed! Task is not available"
}

main()
{
    [[ $dryrun ]] && echo "In dryrun" || sudo echo

    pushd "$REPO"

    # Run install processes
    cmake_build $CONFIG_ARGS $dryrun
    do_make $dryrun
    do_install $dryrun
    task_check

    popd
}
main
