#!/bin/bash

#https://www.cyberciti.biz/faq/how-to-install-openssh-server-on-alpine-linux-including-docker/

adduser -h /home/prvxy -s /bin/sh -D prvxy
echo -n 'prvxy:prvxy' | chpasswd

echo "Initializing SSHD Service..."
ssh-keygen -A
/usr/sbin/sshd -D -e "$@" &

echo "Diretório de trabalho para chaves SSH"
SSH_DIR="/home/prvxy/.ssh"

echo "Creation of the SSH Keys Directory"
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

if [ -f "/usr/local/bin/authorized_keys" ]; then
    echo "Copying authorized_keys."
    mv /usr/local/bin/authorized_keys "${SSH_DIR}/authorized_keys"
fi

echo "Generates a pair of SSH keys without password"
KEY_FILE="${SSH_DIR}/id_rsa"

if [ ! -f "${KEY_FILE}" ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f $KEY_FILE -N ""
    echo "SSH key pair generated."

    echo "Configurando o authorized_keys."
    cat "${SSH_DIR}/id_rsa.pub" >> "${SSH_DIR}/authorized_keys"
fi

chown -R prvxy:prvxy /home/prvxy/

echo "Set the SSH Tunnel for Socks5"
REMOTE_HOST="localhost"  # Using localhost for the internal proxy
REMOTE_PORT=22
SOCKS_PORT=5000  # LOCAL DOOR FOR PROXY SOCKS5
ssh -i "${KEY_FILE}" -o StrictHostKeyChecking=no -v -N -D 0.0.0.0:5000 -p 22 prvxy@localhost &
echo "SOCKS5 proxy initialized on localhost:${SOCKS_PORT}"
