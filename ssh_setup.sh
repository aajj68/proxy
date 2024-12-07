#!/bin/bash

#https://www.cyberciti.biz/faq/how-to-install-openssh-server-on-alpine-linux-including-docker/

adduser -h /home/prvxy -s /bin/sh -D prvxy
echo -n 'prvxy:prvxy' | chpasswd

echo "Inicializando sshd service..."
ssh-keygen -A
/usr/sbin/sshd -D -e "$@" &

echo "Diretório de trabalho para chaves SSH"
SSH_DIR="/home/prvxy/.ssh"

echo "Criação do diretório para chaves SSH"
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

echo "Configurando o authorized_keys."
mv /usr/local/bin/authorized_keys "${SSH_DIR}/authorized_keys"
ls -la "${SSH_DIR}/"

echo "Gera um par de chaves SSH sem senha"
KEY_FILE="${SSH_DIR}/id_rsa"
if [ ! -f "${KEY_FILE}" ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f $KEY_FILE -N ""
    echo "SSH key pair generated."

    echo "Configurando o authorized_keys."
    cat "${SSH_DIR}/id_rsa.pub" >> "${SSH_DIR}/authorized_keys"
fi

chown -R prvxy:prvxy /home/prvxy/

echo "Inicializando sshd service..."
#ssh-keygen -A
#rc-update add sshd &
#service sshd start &
#/usr/sbin/sshd -D -e "$@"

echo "Configura o túnel SSH para SOCKS5"
REMOTE_HOST="localhost"  # Usando localhost para o proxy interno
REMOTE_PORT=22
SOCKS_PORT=5000  # Porta local para o proxy SOCKS5

echo "Setting up SSH SOCKS5 proxy on localhost:${SOCKS_PORT}..."
#ssh -i $KEY_FILE -f -N -D 0.0.0.0:$SOCKS_PORT "0.0.0.0" -p $REMOTE_PORT
#ssh -i $KEY_FILE -f -N -R 0.0.0.0:5000:127.0.0.1:22 user@remote-server
#ssh -f -N -D 0.0.0.0:${SOCKS_PORT} -i $KEY_FILE -p 22 prvxy@localhost &
ssh -i "${KEY_FILE}" -o StrictHostKeyChecking=no -v -N -D 0.0.0.0:5000 -p 22 prvxy@localhost &

#autossh -M 0 -f -N -D ${SOCKS_PORT} -i $KEY_FILE -p $REMOTE_PORT prvxy@$REMOTE_HOST

echo "SOCKS5 proxy initialized on localhost:${SOCKS_PORT}"
