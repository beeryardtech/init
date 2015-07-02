#!/bin/bash -

cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
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
    h) echo $USAGE ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

sudo cpan -i \
CPAN \
Crypt::OpenSSL::RSA \
File::KeePass.pm \
JSON.pm \
Sort::Naturally \
Term::ReadKey.pm \
Term::ShellUI.pm \
