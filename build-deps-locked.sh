#!/bin/bash

(
    flock --timeout 15 200

    sudo DEBIAN_FRONTEND=noninteractive mk-build-deps -i

) 200>/var/lock/.myscript.exclusivelock
