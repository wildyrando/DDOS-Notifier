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
wget --no-check-certificate -O- https://raw.githubusercontent.com/wildyrando/DDOS-Notifier/main/invnstat.sh | bash

# >> Create main directory
rm -rf /etc/ddos-notifier
mkdir -p /etc/ddos-notifier
cd /etc/ddos-notifier

# >> Download resources
wget -O checker.sh https://raw.githubusercontent.com/wildyrando/DDOS-Notifier/main/checker.sh
chmod 700 checker.sh

# >> Download services
wget --no-check-certificate -O /etc/systemd/system/ddos-notifier.service "https://raw.githubusercontent.com/wildyrando/DDOS-Notifier/main/ddos-notifier.service"

# >> Enable services
systemctl enable ddos-notifier

# >> Done
echo -e $"DDOS-Notifier installed successfully,\n\nPlease configure the config files in /etc/ddos-notifier/config.json\n\nand try to start the services with this command\nsystemctl start ddos-notifier"
