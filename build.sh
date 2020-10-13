#!/bin/bash

# We want to fail on bad exit codes
set -e

BASEDIR=$(pwd)
echo ""
echo " ----------------------------------"
echo "| Ensuring a clean build directory |"
echo " ----------------------------------"
echo ""
echo "Directory: $BASEDIR/build/"
cd $BASEDIR
rm -rf build
mkdir build
cd build


echo ""
echo " ----------------------------------------------"
echo "| Downloading Pharo with required Iceberg fork |"
echo " ----------------------------------------------"
echo ""
git clone -b rita2 https://github.com/tinchodias/iceberg.git
./iceberg/scripts/testUpdateIceberg.sh --dev


echo ""
echo " ----------------------------------------"
echo "| Loading code and required dependencies |"
echo " ----------------------------------------"
echo ""
./pharo Pharo.image st --save --quit "../load.st"


echo ""
echo " -------------------------"
echo "| Build Finished: SUCCESS |"
echo " -------------------------"
echo ""
