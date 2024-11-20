#!/bin/bash
source /usr/local/bin/privoxy_start.sh

# Caminho para o arquivo de filtro do Privoxy
PRIVOXY_FILTER="/etc/privoxy/user.filter"

# Função para atualizar o IP externo no arquivo de filtro do Privoxy
update_external_ip() {
    local ip="$1"
    echo "Updating Privoxy filter with IP: $ip"
    # Substitui o IP no filtro
    sed -i "s/content=\"[0-9.]*\"/content=\"$ip\"/" $PRIVOXY_FILTER
}

# Obtém o IP externo inicial
EXTERNAL_IP=$(curl -s ifconfig.me)
update_external_ip $EXTERNAL_IP

privoxy_start()

# Loop para verificar mudanças no IP externo
while true; do
    sleep 300  # Verifica a cada 5 minutos
    NEW_IP=$(curl -s ifconfig.me)
    if [ "$NEW_IP" != "$EXTERNAL_IP" ]; then
        echo "External IP changed from $EXTERNAL_IP to $NEW_IP"
        EXTERNAL_IP=$NEW_IP
        update_external_ip $EXTERNAL_IP
        # Reinicia o Privoxy para aplicar as mudanças
        echo "Restarting Privoxy..."
        killall privoxy
        privoxy_start()
    fi
done