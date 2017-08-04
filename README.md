# Ubuntu no-systemd PPA

https://launchpad.net/~no-systemd/+archive/ubuntu/ppa

Collection of packages for Ubuntu 16 LTS that remove systemd dependencies.

## Related blog posts

* [Xfce4 restart&shutdown without systemd/polkit/consolekit/you-name-kit](https://medium.com/@gdm85/xfce4-restart-shutdown-without-systemd-polkit-consolekit-you-name-kit-8e52ab608ddf)
* [runit as your init on Ubuntu 16 Xenial](https://medium.com/@gdm85/runit-as-your-init-on-ubuntu-16-xenial-55d18513aac0)

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
