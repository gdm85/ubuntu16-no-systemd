#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for xfce4-session
##
#

if [ ! $# -eq 1 ]; then
	echo "Usage: ./xfce4-session.sh output-directory/" 1>&2
	exit 1
fi

OUT="$1"

set -e

## save current directory, where patches are
OWD="$PWD"

## build the patched source
TMPD=$(mktemp -d)
cd "$TMPD"
apt-get source xfce4-session

cd $(find . -name 'xfce4-session-*' -type d)

patch -p1 < "$OWD/xfce4-custom-logout.patch"

"$OWD/build-deps-locked.sh"

set +e
debuild -us -uc -i -I
cd ..

## save generated .deb packages
mv *.deb "$OUT"

## cleanup
cd
rm -rf "$TMPD"
