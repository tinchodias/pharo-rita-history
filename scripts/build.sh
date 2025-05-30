#!/bin/bash

# We want to fail on bad exit codes
set -e

# Define SCRIPTS_DIR and REPO_DIR in a way this script can
# be executed:
#   * from any directory
#   * from linux, macos, and windows (with mingw64)
case "$(uname -s)" in
   MINGW*)
     SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -W )"
     ;;
   *)
     SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
     ;;
esac
REPO_DIR="$(dirname "$SCRIPTS_DIR")"


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
echo " -------------------"
echo "| Downloading Pharo |"
echo " -------------------"
echo ""
curl https://get.pharo.org/130+vm | bash

echo ""
echo " ----------------------------------------"
echo "| Loading code and required dependencies |"
echo " ----------------------------------------"
echo ""
./pharo Pharo.image eval --save $(cat <<EOF
[ EpMonitor disableDuring: [ 
    Metacello new
        baseline: 'Rita';
        repository: 'tonel://$REPO_DIR/src';
        load
] ] timeToRun
EOF
)

echo ""
echo " -------------------------"
echo "| Build Finished: SUCCESS |"
echo " -------------------------"
echo ""
