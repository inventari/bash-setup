#!/bin/bash
INETSTAT=$(ping -oc 100000 cdp.fcs.org > /dev/null && echo "up" || echo "down")
if [[ $INETSTAT == "up" ]]; then
    WHITELIST=$(curl -s http://cdp.fcs.org/management/whitelist.php)
    if [[ $WHITELIST != "FALSE" ]]; then
        networksetup -setproxybypassdomains Wi-Fi $WHITELIST
        networksetup -setproxybypassdomains Ethernet $WHITELIST
    fi

    BLACKLIST=$(curl -s http://cdp.fcs.org/management/blacklist.php)
    if [[ $BLACKLIST != "FALSE" ]]; then
        sudo curl -s http://cdp.fcs.org/management/blacklist.php?hostname=$(hostname) > /etc/hosts
    fi
fi
