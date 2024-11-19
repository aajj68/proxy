#!/bin/bash

# Path to the Privoxy filter file
PRIVOXY_FILTER="/etc/privoxy/external_ip.filter"

# Function to update the external IP in the Privoxy filter file
update_external_ip() {
    local ip=\$1
    echo "Updating Privoxy filter with IP: $ip"
    # Replace the IP in the filter
    sed -i "s/content=\"[0-9.]*\"/content=\"$ip\"/" $PRIVOXY_FILTER
}

# Get the initial external IP
EXTERNAL_IP=$(curl -s ifconfig.me)
update_external_ip $EXTERNAL_IP

# Loop to check for changes in the external IP
while true; do
    sleep 300  # Check every 5 minutes
    NEW_IP=$(curl -s ifconfig.me)
    if [ "$NEW_IP" != "$EXTERNAL_IP" ]; then
        echo "External IP changed from $EXTERNAL_IP to $NEW_IP"
        EXTERNAL_IP=$NEW_IP
        update_external_ip $EXTERNAL_IP
        # Restart Privoxy to apply changes
        systemctl restart privoxy
    fi
done
