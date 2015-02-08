#!/bin/bash -
##
# @name loadperl.sh
# @description
# Install all the PERL modules.
#
# - Uses CPAN to install the modules
##

cleanup()
{
    echo "#### Trapped in loadperl.sh Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

# Grab sudo creds
sudo echo


sudo cpan -i \
Crypt::OpenSSL::RSA \
File::KeePass.pm \
JSON.pm \
Sort::Natuarlly.pm \
Term::ReadKey.pm \
Term::ShellUI.pm \
