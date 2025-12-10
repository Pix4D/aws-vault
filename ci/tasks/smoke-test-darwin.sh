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
