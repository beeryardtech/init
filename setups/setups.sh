#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Does initial setups

- Make directories
- Copy files
- Create firewall rules
- Link files and folders

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

mk_dirs()
{
    local dry=$1

    # Dirs
    local repos=~/repos
    local tmp_dir=~/tmp
    local tmp_move=~/tmp/moved

    local dir_list="$repos $tmp_dir $tmp_move"

    if [[ $dry ]] ; then
        echo "Dirs: $dir_list"
        return
    fi

    mkdir -p $dir_list
}

mk_links()
{
    local dry=$1

    local bin=~/Dropbox/repos/beeryardtech/scripts/bin
    local dots=~/Dropbox/repos/beeryardtech/scripts/dots
    local init=~/Dropbox/repos/beeryardtech/init
    local ip=~/Dropbox/repos/integrityprops/libs
    local ui=~/Dropbox/repos/nextgen/ui


    if [[ $dry ]] ; then
        local link_list="$bin $dots $init $ip $ui"
        echo "Link list: $link_list"
        return
    fi

    # Do links
    ln -s "$bin" ~/bin
    ln -s "$dots" ~/dots
    ln -s "$init" ~/inits
    ln -s "$ip" ~/ip
    ln -s "$ui" ~/ui
}

cp_files()
{
    local dry=$1
    local move_dir=~/tmp/moved
    local file_dir="${CURRENT_DIR}/../files/"

    if [[ $dry ]] ; then
        echo "Cp list: $cp_list"
        return
    fi

    cp /etc/apt/sources.list $move_dir
    cp /etc/systemd/logind.conf $move_dir
    cp /usr/share/X11/xorg.conf.d/20-intel.conf $move_dir

    sudo cp $file_dir/sources.list.trusty /etc/apt/sources.list
    sudo cp $file_dir/20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf
    sudo cp $file_dir/logind.conf /etc/systemd/logind.conf
}

firewall()
{
    local dry=$1

    if [[ $dry ]] ; then
        echo "Link list: $link_list"
        return
    fi

    sudo ufw enable
    sudo ufw allow proto tcp from any to any port 1714:1764
}

main()
{
    cp_files $dryrun
    mk_dirs $dryrun
    mk_links $dryrun
    #firewall $dryrun
}
main
