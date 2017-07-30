#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for polkit
##
#

if [ ! $# -eq 1 ]; then
	echo "Usage: ./gvfs.sh output-directory/" 1>&2
	exit 1
fi

OUT="$1"

set -e

## save current directory, where patches are
OWD="$PWD"

## build the patched source
TMPD=$(mktemp -d)
cd "$TMPD"
apt-get source policykit-1

cd $(find . -name 'policykit-1-*' -type d)

## remove systemd references
patch -p1 < "$OWD/policykit-misc.patch"

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
