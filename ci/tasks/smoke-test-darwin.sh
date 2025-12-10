#! /bin/sh

set -e

: "${VERSION?The pipeline must set this parameter}"

cd artifacts
# ITERATE OVER ALL THE DARWIN ARCHIVES
for MAC_ARCHIVE in $(ls *.zip); do
    # CREATE A SPECIFIC DIRECTORY FOR THE ARTIFACT TO PREVENT OVERWRITING
    ARTIFACT_DIRECTORY=$(basename $MAC_ARCHIVE .zip)
    mkdir $ARTIFACT_DIRECTORY
    unzip $MAC_ARCHIVE -d $ARTIFACT_DIRECTORY

    echo
    echo Entering $ARTIFACT_DIRECTORY
    cd $ARTIFACT_DIRECTORY

    echo
    echo Smoke tests
    echo
    echo "Test if aws-vault has embedded the correct version"
    # We need to redirect stderr to stdout because aws-vault's CLI library prints version to stderr.
    ./aws-vault --version 2>&1 | grep "$VERSION"
    echo
    echo "Test if aws-vault prints help for a subcommand"
    ./aws-vault exec --help

    echo
    echo Exiting $ARTIFACT_DIRECTORY
    cd ..

done
