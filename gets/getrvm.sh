#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Installs the Ruby Environment Manager (rvm)

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

get_key()
{
    local dry=$1
    local key=409B6B1796C275462A1703113804BB82D39DC0E3

    if [[ $dry ]] ; then
        echo "Will install key $key"
        return
    fi

    gpg --keyserver hkp://keys.gnupg.net --recv-keys $key
    err=$?
    die $err "Failed to get key!"
}

do_install_rvm()
{
    local dry=$1
    local opts=--ignore-dotfiles
    if [[ $dry ]] ; then
        echo "Will install with opts: $opts"
        return
    fi

    \curl -sSL https://get.rvm.io | bash -s -- $opts
    err=$?
    die $err "Failed to do install!"
}

do_install_ruby()
{
    local dry=$1
    local opts="install ruby-2.1-head"
    if [[ $dry ]] ; then
        echo "Will install ruby version with opts: $opts"
        return
    fi

    source ~/.rvm/scripts/rvm
    rvm install $opts
}

do_install_gems()
{
    local dry=$1
    local opts="install ruby-2.1-head"
    if [[ $dry ]] ; then
        echo "Will install gems with opts: $opts"
        return
    fi

    gem install jekyll
}

main()
{
    sudo echo

    get_key $dryrun
    do_install_rvm $dryrun
    do_install_ruby $dryrun
}
main
