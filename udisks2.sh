#!/bin/bash
## @author gdm85
##
## Script to build and install a customized .deb package for udisks2
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
apt-get source udisks2

cd $(find . -name 'udisks2-*' -type d)

## remove systemd references
cd debian
grep -vF systemd control > control.1
mv control.1 control
grep -vF systemd udisks2.install > new
mv new udisks2.install
cd ..
cat<<'EOF' | patch -p1
--- a/debian/rules	2017-03-21 00:44:48.508422271 +0100
+++ b/debian/rules	2017-03-21 00:44:56.636422335 +0100
@@ -8,8 +8,7 @@
 		--libexecdir=/usr/lib \
 		--disable-silent-rules \
 		--enable-gtk-doc \
-		--enable-fhs-media \
-		--with-systemdsystemunitdir=/lib/systemd/system
+		--enable-fhs-media
 
 override_dh_auto_build:
 	dh_auto_build
EOF

"$OWD/build-deps-locked.sh"

## from https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-fs/udisks/udisks-2.1.3.ebuild?view=markup
#sed -i -e 's:libsystemd-login:&disable:' configure
cp "$OWD/10_disable-systemd.patch" debian/patches/
echo "10_disable-systemd.patch" >> debian/patches/series

debuild -us -uc -i -I
cd ..

## save generated .deb packages
mv *.deb "$OUT"

## cleanup
cd
rm -rf "$TMPD"
