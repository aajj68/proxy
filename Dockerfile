# Use the base image from the existing setup
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache openssh-client autossh curl privoxy && \
    rm -rf /var/cache/apk/*

# Copy the update script into the container
COPY update_privoxy_ip.sh /usr/local/bin/update_privoxy_ip.sh

# Make the script executable
RUN chmod +x /usr/local/bin/update_privoxy_ip.sh

# Add the cron job
RUN echo "*/5 * * * * /usr/local/bin/update_privoxy_ip.sh" > /etc/crontabs/root

# Entry point to start services
CMD ["sh", "-c", "crond && privoxy --no-daemon /etc/privoxy/config"]