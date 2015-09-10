init
=====
Scripts and packages to help get my systems going.


## Order to Run Scripts

- setups.sh
- linkify.sh
- installs.sh
- setupdropbox.sh
- setupwine.sh
- dogets.sh
- dobuilds.sh
- init.sios.sh

## Code Standards
These are the basic principles of running install scripts for testability, readability, and consistency.

### Usage and Arguments (Header)
```bash
#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
---- Description ----

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
```

### Organizing
Use bash functions for each piece. End the script with a `main()` function that simply
runs the other functions.

Check error codes (typically store `$?` in `$err`) as you go. Output when something errors out.

```
main()
{
    do_some_logic
    get_first
    get_something_else
}
main
```

## Notes and Manual Instructions

``` bash
###
# Disable IPv6
###
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
### Wget apps

``` bash
wget -O  ~/tmp | tar xvf -
```
### To change Screensaver lock for cinnamon
- Open dconf editor
- org -> cinnamon -> desktop -> settings-daemon -> media-keys -> "screensaver"
- Apply settings

### To prevent suspend when lid closed
- Edit /etc/logind.conf
- Change the following values:
    - HandleLidSwitch=ignore
    - LidSwitchIgnoreInhibited=no
