# Ubuntu no-systemd PPA

https://launchpad.net/~no-systemd/+archive/ubuntu/ppa

Collection of packages for Ubuntu 16 LTS that remove systemd dependencies.

## Related blog posts

* https://medium.com/@gdm85/xfce4-restart-shutdown-without-systemd-polkit-consolekit-you-name-kit-8e52ab608ddf

# Building the packages

```shell
$ make -j
```

# Installing the  packages

```shell
$ make install
```

# Custom XFCE4 session logout

```shell
$ ./install-custom-session-logout.sh
```

# License

[GNU/GPL v2](LICENSE)
