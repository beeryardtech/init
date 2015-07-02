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

### Perl Modules

``` bash
cpan -i Sort/Natuarlly.pm \
Term/ReadKey.pm \
Term/ShellUI.pm \
File/KeePass.pm
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
