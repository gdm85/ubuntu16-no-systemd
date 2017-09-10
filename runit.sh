#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for runit
##
#

if [ ! $# -eq 1 ]; then
	echo "Usage: ./runit.sh output-directory/" 1>&2
	exit 1
fi

OUT="$1"

set -e

## save current directory, where patches are
OWD="$PWD"

## build the patched source
TMPD=$(mktemp -d)
cd "$TMPD"
apt-get source runit

cd $(find . -name 'runit*' -type d)

patch -p1 < "$OWD/runit-rules.patch"
cp "$OWD/0005-misc-ubuntu-fixes.diff" debian/diff/

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
