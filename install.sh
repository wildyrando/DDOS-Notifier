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

# >> Install vnstat and requirements
wget --no-check-certificate -O- 