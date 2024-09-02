#!/bin/bash

# Capture the external IP address
EXTERNAL_IP=$(curl -s ifconfig.me)

# Path to the Privoxy configuration file
PRIVOXY_CONFIG="/etc/privoxy/config"

# Update the Privoxy configuration with the new IP address
# Remove any existing line with 'forward-add-header' and add the new one
sed -i '/forward-add-header {external-ip}/d' $PRIVOXY_CONFIG
echo "forward-add-header {external-ip} $EXTERNAL_IP" >> $PRIVOXY_CONFIG

# Determine the host's IP address
HOST_IP=$(hostname -I | awk '{print \$1}')

# Extract the last octet of the host's IP address to determine the SOCKS5 port
LAST_OCTET=$(echo $HOST_IP | awk -F. '{print \$4}')
SOCKS5_PORT=$((5000 + LAST_OCTET))

# Restart the Privoxy service to apply changes
service privoxy restart