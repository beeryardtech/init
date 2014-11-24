#!/bin/bash -
#===============================================================================
#         USAGE: ./generated.sources.sh
#
#   DESCRIPTION:
#        AUTHOR: Travis Goldie
#  ORGANIZATION:
#       CREATED: 11/08/2013 16:10
#===============================================================================
# Only should be ran as root
if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root" 1>&2
    exit 1
fi
cleanup()
{
    echo "Trapped! Booh!"
    exit 255
}
trap cleanup SIGINT SIGTERM

# Gernated by http://repogen.simplylinux.ch/generate.php
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 614C4B38
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6E80C6B7
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 75198A89
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 28949509
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B1510FD
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4C9D234C

# XFCE4 - Xbuntu
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 142986CE
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8AC93F7A
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1378B444
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0624A220
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FC91AE7E
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0FEB6DD9
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E9CFF4E

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE56EB12FA2AF90A
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 83549DA35C8B1281

# Tor project
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 74A941BA219EC810

# Weather indicator
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A9653F936FD5529

# Solaar
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 90AACB8406524FBA

# Dropbox
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5044912E

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 082CCEDF94558F59
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 32B18A1260D8DA0B
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 44270923C32A36BF
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B998019EC07BBEC4
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 896DFFD3F124D11B
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B9316A7BC7917B12


echo
echo "*** Apt-key fetches done. Moving to gpg adds..."
echo

gpg --keyserver subkeys.pgp.net --recv 60D8DA0B && gpg --export --armor 60D8DA0B  | apt-key add -
gpg --keyserver subkeys.pgp.net --recv 886DDD89 && gpg --export --armor 886DDD89  | apt-key add -

gpg --keyserver subkeys.pgp.net --recv 082CCEDF94558F59 && gpg --export --armor 082CCEDF94558F59 | apt-key add -
gpg --keyserver subkeys.pgp.net --recv F24AEA9FB05498B7 && gpg --export --armor F24AEA9FB05498B7 | apt-key add -
gpg --keyserver subkeys.pgp.net --recv 32B18A1260D8DA0B && gpg --export --armor 32B18A1260D8DA0B | apt-key add -
gpg --keyserver subkeys.pgp.net --recv 44270923C32A36BF && gpg --export --armor 44270923C32A36BF | apt-key add -
gpg --keyserver subkeys.pgp.net --recv B998019EC07BBEC4 && gpg --export --armor B998019EC07BBEC4 | apt-key add -
gpg --keyserver subkeys.pgp.net --recv 896DFFD3F124D11B && gpg --export --armor 896DFFD3F124D11B | apt-key add -
gpg --keyserver subkeys.pgp.net --recv B9316A7BC7917B12 && gpg --export --armor B9316A7BC7917B12 | apt-key add -


echo "GPG keyserver fetches done. Using wget to get keys..."
wget -O - http://www.bchemnet.com/suldr/suldr.gpg | apt-key add -
wget -q http://liveusb.info/multisystem/depot/multisystem.asc -O- | apt-key add -
wget http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O- | apt-key add -
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key| apt-key add -

# Finally end updating apt-get
apt-get update

