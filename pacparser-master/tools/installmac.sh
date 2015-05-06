#!/bin/sh -e
#
# This script creates a staging directory for Mac package, then installs the 
# files in the root directory for Terminal usage.  This is a modification of 
# the Package maker script that leverage Apple Package Maker, which has been
# deprecated as of Xcode 4.6.

ver=$1
[ -z $ver ] && echo "Please specify package version." && exit

# $stage_dir is where we'll install our package files.
stage_dir=/tmp/pacparser_$RANDOM
sudo rm -rf /tmp/pacparser*
mkdir -p $stage_dir

if [ ! -e src/Makefile ]; then
  echo "Call this script from the root of the source directory"
  exit 1
fi

# Build pactester and pacparser library and install in $stage_dir
make -C src
DESTDIR=$stage_dir make -C src install
# Build python module and install it in $stage_dir
make -C src pymod
DESTDIR=$stage_dir make -C src install-pymod

sudo chown -R root:wheel ${stage_dir}

#Install files in root directory for Terminal usage.
cd ${stage_dir}

sudo ditto . /