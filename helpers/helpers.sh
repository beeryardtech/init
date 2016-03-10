#!/bin/bash -

##
# @description
# Runs default cleanup function. Use in a trap on signals
#
# ```
# trap cleanup SIGINT SIGTERM
# ```
cleanup()
{
    echo "#### Trapped in $( basename $0 ). Exiting."
    exit 255
}

##
# @description
# Checks to see if a given script is ran as sudo (or root).
# If not exits with error code 1 and outputs message to STDERR.
#
# ```
# $ cat "myscript.sh"
#  check_sudo
#  echo "my user name $(whoami)"
#
# $ sudo myscript.sh
#  my user name root
#
# $ myscript.sh
#  Must run as root!
# ```
##
check_sudo()
{
    local msg="Must Run this script as root!"

    if [[ $(whoami) != "root" ]] ; then
        echo $msg >&2
        exit 1
    fi
}

##
# @description
# Checks to see if error code is non-zero. If so, echo message and exit
# with the given error code.
#
# ```
# $ someCmd blah blah2
# $ err=$?
# $ die $err "If err is non-zero this script will exit"
# ```
##
die()
{
    local err=$1
    local msg=$2
    local name=$( basename $0 )

    if [[ $err != 0 ]] ; then
        echo "[ERROR]:${name}:code $err:${msg}"
        exit $err
    fi
}

##
# @description
# Create a path to save files (deb or tar) from the url.
#
# Echos the result
#
# ```bash
# $ url="http://example.com/file.deb"
# $ path=$( get_path_from_url $url )
# $ ## Result: ~/tmp/file.deb
#```
##
get_path_from_url()
{
    local url=$1
    local dir="$HOME/tmp/"
    local name=$( basename "$url" )

    echo "${dir}/${name}"
}
