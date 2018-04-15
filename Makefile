
PKGS:=udisks2 policykit-1 gvfs xfce4-session initscripts runit

all: $(PKGS)
	@echo ".deb files generated in deb/, now run 'make install' for installation"

## proceed to installation & pinning of packages
install:
	sudo apt-get install -y x11-utils
	sudo dpkg -i debs/*.deb
	sudo apt-mark hold gvfs-common gvfs-daemons gvfs-libs gvfs-backends policykit-1 udisks2 xfce4-session

udisks2: build-deps
	mkdir -p debs/
	./udisks2.sh "$(CURDIR)/debs"

policykit-1: build-deps
	mkdir -p debs/
	./policykit-1.sh "$(CURDIR)/debs"

gvfs: build-deps
	mkdir -p debs/
	./gvfs.sh "$(CURDIR)/debs"

xfce4-session: build-deps
	mkdir -p debs/
	./xfce4-session.sh "$(CURDIR)/debs"

initscripts: build-deps
	mkdir -p debs/
	./initscripts.sh "$(CURDIR)/debs"

runit: build-deps
	mkdir -p debs/
	./runit.sh "$(CURDIR)/debs"

## install necessary packages for building debs
build-deps:
	sudo apt-get install -y fakeroot devscripts build-essential equivs
	sudo apt-get build-dep -y runit
	sudo apt-get build-dep -y xfce4-session ## avoid pulling in systemd and libsystemd-dev

.PHONY: all $(PKGS) build-deps install
