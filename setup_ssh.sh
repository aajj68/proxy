#!/bin/bash

# Diretório de trabalho para chaves SSH
SSH_DIR="/root/.ssh"

# Criação do diretório para chaves SSH
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

# Gera um par de chaves SSH sem senha
KEY_FILE="${SSH_DIR}/id_rsa"
if [ ! -f "${KEY_FILE}" ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f $KEY_FILE -N ""
    echo "SSH key pair generated."
fi

# Configura o túnel SSH para SOCKS5
REMOTE_HOST="remote.server.com"
REMOTE_PORT=22
SOCKS_PORT=5000  # Porta local para o proxy SOCKS5

echo "Setting up SSH SOCKS5 proxy on localhost:${SOCKS_PORT}..."
autossh -M 0 -f -N -D ${SOCKS_PORT} -i $KEY_FILE -p $REMOTE_PORT root@$REMOTE_HOST

echo "SOCKS5 proxy initialized on localhost:${SOCKS_PORT}"