# Use the base image from the existing setup
FROM alpine:latest

# Substitui o repositório padrão por um espelho alternativo
#RUN sed -i 's|https://dl-cdn.alpinelinux.org/alpine/|https://mirror.clarkson.edu/alpine/|' /etc/apk/repositories
#RUN sed -i 's/https/http/' /etc/apk/repositories
#RUN apk add curl
# Atualiza os repositórios e instala os pacotes necessários
RUN apk update && \
    apk upgrade && \
    apk add openssh openssh-client autossh curl privoxy bash

# Limpa o cache do apk (opcional, mas recomendado para reduzir o tamanho da imagem)
RUN rm -rf /var/cache/apk/*

# Copy configuration scripts into the container
COPY ssh_setup.sh /usr/local/bin/ssh_setup.sh
COPY privoxy_setup.sh /usr/local/bin/privoxy_setup.sh
COPY privoxy_start.sh /usr/local/bin/privoxy_start.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/ssh_setup.sh /usr/local/bin/privoxy_setup.sh /usr/local/bin/privoxy_start.sh

# Rename .new configuration files to their correct names
#RUN cd /etc/privoxy && \
#    for file in *.new; do \
#        cp "$file" "${file%.new}"; \
#    done

# Copy the custom Privoxy config file into the container
COPY config /etc/privoxy/config
COPY user.filter /etc/privoxy/user.filter
COPY user.action /etc/privoxy/user.action
COPY sshd_config /etc/ssh/sshd_config

# Entrypoint to initialize configurations
CMD ["/bin/sh", "-c", "/usr/local/bin/ssh_setup.sh && /usr/local/bin/privoxy_setup.sh"] 
# && tail -f /dev/null"]
