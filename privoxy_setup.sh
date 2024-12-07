#!/bin/bash
source "/usr/local/bin/privoxy_start.sh"
echo "Starting Privoxy..."
/usr/sbin/privoxy --no-daemon --pidfile "${PID_FILE}" "${CFG_FILE}" &
