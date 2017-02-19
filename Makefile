
PKGS:=udisks2 policykit-1 gvfs xfce4-session

all: $(PKGS)
	@echo ".deb files generated in deb/, now run 'make install' for installation"

## proceed to installation & pinning of packages
install:
	sudo apt-get install -y x11-utils
	sudo dpkg -i debs/*.deb
	sudo apt-mark hold gvfs-common gvfs-daemons gvfs-libs gvfs-backends
	sudo apt-mark hold policykit-1
	sudo apt-mark hold udisks2

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

## install necessary packages for building debs
build-deps:
	sudo apt-get install -y fakeroot devscripts build-essential equivs
	sudo apt-get build-dep xfce4-session ## avoid pulling in systemd and libsystemd-dev

.PHONY: all udisks2 policykit-1 gvfs xfce4-session build-deps install
