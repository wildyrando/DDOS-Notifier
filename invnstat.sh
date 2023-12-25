#!/bin/bash

# DDOS-Notifier
# This bash script detects possible DDOS attacks and sends notifications if supspicious activity is detected.

# Author: Wildy Sheverando [ hai@wildyrando.com ]

# This Project Licensed Under The MIT License.

# ===================================================================================================================

# >> check root permissions
if [[ $(whoami) != "root" ]]; then
    echo "This script requires root permissions"
    exit 1
fi

# >> Check os command
if ! command -V apt > /dev/null 2>&1; then
    echo "This script only supports on debian systems"
    exit 1
fi

# >> Update repository
apt update -y; apt upgrade -y

# >> Install vnstat
apt install vnstat jq -y

# >> Check vnstat installation
if ! command -V vnstat > /dev/null 2>&1; then
    echo "Vnstat is not installed, please install it manually"
    exit 1
fi

# >> Check JQ installations
if ! command -V jq > /dev/null 2>&1; then
    echo "JQ is not installed, please install it manually"
    exit 1
fi