#!/bin/bash

# Put into /lib/systemd/system-sleep/suspend-modules
# chmod a+x /lib/systemd/system-sleep/suspend-modules

# Unloads kernel modules defined in /etc/suspend-modules.d/*.conf
# and /etc/suspend-modules
# with one module per line

# Too see credits, see git history
# https://gist.github.com/sigboe/2602f9318b8f55ca92c7755a5b70644d/edit

case $1 in
    pre)
        for mod in $(cat /etc/suspend-modules 2> /dev/null; awk 1 /etc/suspend-modules.d/*.conf 2> /dev/null); do
            rmmod $mod
        done
    ;;
    post)
        for mod in $(cat /etc/suspend-modules 2> /dev/null; awk 1 /etc/suspend-modules.d/*.conf 2> /dev/null); do
            modprobe $mod
        done
    ;;
esac