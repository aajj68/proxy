# Use the base image from the existing setup
FROM caligari/privoxy:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-client autossh cron curl && \
    apt-get clean

# Copy the update script into the container
COPY update_privoxy_ip.sh /usr/local/bin/update_privoxy_ip.sh

# Make the script executable
RUN chmod +x /usr/local/bin/update_privoxy_ip.sh

# Add the cron job
RUN echo "*/5 * * * * /usr/local/bin/update_privoxy_ip.sh" > /etc/cron.d/update_privoxy_ip

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/update_privoxy_ip

# Apply cron job
RUN crontab /etc/cron.d/update_privoxy_ip

# Entry point to start services
CMD ["sh", "-c", "service cron start && privoxy --no-daemon /etc/privoxy/config"]