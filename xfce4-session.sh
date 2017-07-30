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

patch -p1 < "$OWD/xfce4-chglog.patch"

cp "$OWD/10_xfce4-custom-logout.patch" debian/patches/
echo 10_xfce4-custom-logout.patch >> debian/patches/series

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
