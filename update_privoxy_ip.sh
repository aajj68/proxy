#!/bin/bash

#set -x

# Capture the external IP address
EXTERNAL_IP=$(curl -s ifconfig.me)
SOCKS5_PORT=5016

cd /etc/privoxy
for file in *.new; do
    cp "$file" "${file%.new}"
done

# Path to the Privoxy configuration file
PRIVOXY_FILTER="/etc/privoxy/insert-comment.filter"

# Update the Privoxy configuration with the new IP address
# Remove any existing line with 'forward-add-header' and add the new one
# sed -i "s/+add-header{x-externalip: [^}]*}/+add-header{x-externalip: $EXTERNAL_IP}/" $PRIVOXY_FILTER
# echo "forward-add-header {external-ip} $EXTERNAL_IP" >> $PRIVOXY_CONFIG

# Restart the Privoxy service to apply changes
# Encontra o PID do processo privoxy
PROC=$(ps aux | grep privoxy | grep -v grep | awk "{print \$1}" | head -n 1)

# Verifica se o PID foi encontrado e mata o processo
if [ -n "$PROC" ]; then
  kill $PROC &
fi

privoxy --no-daemon /etc/privoxy/config &
