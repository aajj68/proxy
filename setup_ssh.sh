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

# Adiciona a chave pública ao arquivo authorized_keys
AUTHORIZED_KEYS="${SSH_DIR}/authorized_keys"
if [ ! -f "${AUTHORIZED_KEYS}" ]; then
    echo "Adding public key to authorized_keys..."
    cat "${KEY_FILE}.pub" >> "${AUTHORIZED_KEYS}"
    chmod 600 "${AUTHORIZED_KEYS}"
    echo "Public key added to authorized_keys."
fi

# Configurações do SSHD
SSHD_CONFIG="/etc/ssh/sshd_config"
if grep -q "^#PubkeyAuthentication" $SSHD_CONFIG; then
    echo "Enabling PubkeyAuthentication in sshd_config..."
    sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG
fi

if grep -q "^#PasswordAuthentication" $SSHD_CONFIG; then
    echo "Disabling PasswordAuthentication in sshd_config..."
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
fi

# Reinicia o serviço SSH para aplicar as mudanças
echo "Restarting SSH service..."
service ssh restart

# Configura o túnel SSH para SOCKS5
REMOTE_HOST="localhost"  # Usando localhost para o proxy interno
REMOTE_PORT=22
SOCKS_PORT=5000  # Porta local para o proxy SOCKS5

echo "Setting up SSH SOCKS5 proxy on localhost:${SOCKS_PORT}..."
autossh -M 0 -f -N -D ${SOCKS_PORT} -i $KEY_FILE -p $REMOTE_PORT root@$REMOTE_HOST

echo "SOCKS5 proxy initialized on localhost:${SOCKS_PORT}"