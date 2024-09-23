# Use the base image from the existing setup
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache openssh-client autossh bash curl privoxy python3 && \
    rm -rf /var/cache/apk/*

#RUN chmod +x /app/privoxy.sh && rm -rf /etc/init.d/privoxy

# Copy the update script into the container
COPY config /etc/privoxy/config.new
COPY getip.js /usr/local/bin/getip.js
COPY update_privoxy_ip.sh /usr/local/bin/update_privoxy_ip.sh

# Make the script executable
RUN chmod +x /usr/local/bin/update_privoxy_ip.sh
RUN /usr/local/bin/update_privoxy_ip.sh

# Add the cron job
#RUN echo "*/5 * * * * /usr/local/bin/update_privoxy_ip.sh" > /etc/crontabs/root

# Entry point to start services
CMD ["sh", "-c", "crond && tail -f /dev/null"]
