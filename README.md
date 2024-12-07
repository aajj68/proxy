# About

This container provides a privoxy proxy and a socks5 proxy

# Useful commands for launching Docker containers

```
docker-compose down && docker-compose up -d
docker-compose up --build -d
```
<!-- docker build --progress=plain -t proxy . PRIVOXY_PORT=8118 SOCKS5_PORT=5000 docker-compose up --build -d -->

# Setup Windows Firewall for open ports

__Execute as admin__
```
netsh advfirewall firewall add rule name="Abrir Porta 8118" dir=in action=allow protocol=TCP localport=8118
netsh advfirewall firewall add rule name="Abrir Porta 5000" dir=in action=allow protocol=TCP localport=5000
netsh advfirewall firewall add rule name="Abrir Porta 5022" dir=in action=allow protocol=TCP localport=5022
```
# SSH access
To access by ssh type:
```
ssh prvxy@server_ip -p 5022
```
you need to put your public key in file __authorized_access__ in root of project. The software will copy this file to container.