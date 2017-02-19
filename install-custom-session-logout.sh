#!/bin/bash

set -e

if ! dpkg-divert --list | grep -qF /usr/bin/xfce4-session-logout; then
	dpkg-divert --divert /usr/bin/xfce4-session-logout.orig --rename /usr/bin/xfce4-session-logout
fi

echo '%sudo ALL=NOPASSWD:/sbin/shutdown' > /etc/sudoers.d/allow-shutdown:

sudo cp custom-session-logout /usr/local/bin/xfce4-session-logout
