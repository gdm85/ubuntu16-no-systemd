#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for gvfs
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
apt-get source gvfs

cd $(find . -name 'gvfs-*' -type d)

## remove systemd references
cd debian
grep -vF systemd control > control.1
grep -vF systemd control.in > control.in.1
mv control.1 control
mv control.in.1 control.in
cd ..

"$OWD/build-deps-locked.sh"

patch -p1 < "$OWD/gvfs-rules.patch"

## remove more systemd-generated expected files
for F in debian/*.install; do
	grep -vF usr/lib/systemd "$F" > new.install
	truncate --size=0 "$F"
	cat new.install >> "$F"
done
rm new.install

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
