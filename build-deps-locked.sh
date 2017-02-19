#!/bin/bash

(
    flock --timeout 15 200

    sudo mk-build-deps -i

) 200>/var/lock/.myscript.exclusivelock
