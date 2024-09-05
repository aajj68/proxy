docker-compose up --build -d 
PRIVOXY_PORT=8123 SOCKS5_PORT=5004 docker-compose up --build -d

netsh advfirewall firewall add rule name="Abrir Porta 8118" dir=in action=allow protocol=TCP localport=8118
netsh advfirewall firewall add rule name="Abrir Porta 5016" dir=in action=allow protocol=TCP localport=5016