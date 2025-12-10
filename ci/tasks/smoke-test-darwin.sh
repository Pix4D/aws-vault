#! /bin/bash

set -e

banner() {
    echo
    echo "######################################################################"
    echo "$*"
}

: "${VERSION?The pipeline must set this parameter}"
cd artifacts

unzip *.zip

banner "Test if aws-vault has embedded the correct version"
# We need to redirect stderr to stdout because aws-vault's CLI library prints version to stderr.
./aws-vault --version 2>&1 | grep "$VERSION"

banner "Test if aws-vault prints help for a subcommand"
./aws-vault exec --help

banner "Test if aws-vault uses the macOS keychain as backend (PCI-4572)"
./aws-vault --help 2>&1 | grep backend
./aws-vault --help 2>&1 | grep backend=keychain
