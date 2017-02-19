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

cat<<'EOF' | patch -p1
--- a/debian/rules	2017-03-20 23:54:22.832398302 +0100
+++ b/debian/rules	2017-03-20 23:54:38.456398426 +0100
@@ -20,5 +20,6 @@
 DEB_CONFIGURE_EXTRA_FLAGS += \
 	--libdir=/usr/lib/$(DEB_HOST_MULTIARCH) \
 	--libexecdir=/usr/lib/gvfs \
-	--disable-hal
-
+	--disable-hal \
+	--disable-libsystemd-login \
+	--with-systemduserunitdir=no
--- a/debian/gvfs-common.install	2017-03-21 00:25:18.948413006 +0100
+++ b/debian/gvfs-common.install	2017-03-21 00:25:25.608413059 +0100
@@ -1,4 +1,3 @@
 usr/share/locale
 usr/share/man/man1
 usr/share/man/man7
-usr/lib/tmpfiles.d/gvfsd-fuse-tmpfiles.conf
EOF

## remove more systemd-generated expected files
for F in debian/*.install; do
	grep -vF usr/lib/systemd "$F" > new.install
	truncate --size=0 "$F"
	cat new.install >> "$F"
done
rm new.install

debuild -us -uc -i -I
cd ..

## save generated .deb packages
mv *.deb "$OUT"

## cleanup
cd
rm -rf "$TMPD"
