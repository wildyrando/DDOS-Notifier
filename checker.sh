#!/bin/bash

# DDOS-Notifier
# This bash script detects possible DDOS attacks and sends notifications if supspicious activity is detected.

# Author: Wildy Sheverando [ hai@wildyrando.com ]

# This Project Licensed Under The MIT License.

# ===================================================================================================================

# >> Check vnstat installation status
if ! command -V vnstat > /dev/null; then
    echo "ERROR: vnstat not installed"
    exit 1
fi

# >> Check sudoer permissions
if [[ $(whoami) != "root" ]]; then
    echo "ERROR: You must be root to run this script"
    exit 1
fi

# >> Load configuration
export name=$(cat config.json | jq -r '.name')
export limits=$(cat config.json | jq -r '.bandwidth')
export teleapi=$(cat config.json | jq -r '.bottoken')
export teleid=$(cat config.json | jq -r '.teleid')
export intf=$(cat config.json | jq -r '.interfaces')

# >> Looping
while true; do
    export bytes="$(/usr/bin/vnstat -i $intf -tr 2 --json | jq -r ".rx.bytespersecond")"
    export conmbps=$(echo $bytes | awk '{printf "%d", $1 * 8 / 1024 / 1024}')

    if [ "$conmbps" -gt "$limits" ]; then
        export msg="Helooo, Im ur DDOS Notifier\n\nServer [$name]\n\nDetected a DDOS attack incoming with a rate of $conmbps Mbps.\n\nTime: $(date +"%d-%m-%Y %H:%M:%S")\n\nPlease investigate and secure your server now."
        msg=$(echo -e "$msg")
        export response="$(wget -nv -q -O- --server-response --no-check-certificate "https://api.telegram.org/bot$teleapi/sendMessage?chat_id=$teleid&text=$msg&parse_mode=Markdown" 2>&1)"

        if [[ "$(echo $response | grep -w "200 OK")" ]]; then
            echo "Notification sent successfully."
        else
            echo "Failed to send notification. Response: $response"
        fi

        # >> Inserting to logs
        echo "$(date) | ddos detected, rate : $conmbps Mbps" >> activity.log

        # >> waiting for 30 mins
        sleep 1800
    fi

    # >> sleep for 5 seconds
    sleep 5
done;