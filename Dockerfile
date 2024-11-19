# Use the base image from the existing setup
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache openssh-client autossh curl privoxy && \
    rm -rf /var/cache/apk/*

# Copy configuration scripts into the container
COPY setup_ssh.sh /usr/local/bin/setup_ssh.sh
COPY setup_privoxy.sh /usr/local/bin/setup_privoxy.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/setup_ssh.sh /usr/local/bin/setup_privoxy.sh

# Rename .new configuration files to their correct names
RUN cd /etc/privoxy && \
    for file in *.new; do \
        cp "$file" "${file%.new}"; \
    done

# Copy the custom Privoxy config file into the container
COPY privoxy.config /etc/privoxy/config

# Entrypoint to initialize configurations
CMD ["/bin/bash", "-c", "/usr/local/bin/setup_ssh.sh && /usr/local/bin/setup_privoxy.sh && tail -f /dev/null"]