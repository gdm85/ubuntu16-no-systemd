#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for initscripts
##
#

if [ ! $# -eq 1 ]; then
	echo "Usage: ./initscripts.sh output-directory/" 1>&2
	exit 1
fi

OUT="$1"

set -e

## save current directory, where patches are
OWD="$PWD"

## build the patched source
TMPD=$(mktemp -d)
cd "$TMPD"
apt-get source initscripts

cd $(find . -name 'sysvinit*' -type d)

patch -p1 < "$OWD/initscripts.patch"

"$OWD/build-deps-locked.sh"

if [ ! -z "$PPA_UPDATE" ]; then
	"$OWD/ppa-update.sh"
else
	debuild -us -uc -i -I
	cd ..

	## save generated .deb packages
	mv *.deb "$OUT"
fi

## cleanup
cd
rm -rf "$TMPD"
