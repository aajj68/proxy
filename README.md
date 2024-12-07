# About

This container provides a Privoxy proxy and a SOCKS5 proxy. It is useful for sharing a VPN connection among computers in your home network, especially since VPN providers, like NordVPN, often impose a limit on simultaneous connections (e.g., NordVPN limits it to 5 connections).

# Privoxy filters and actions

For __user.action__ and __filter.action__, you need to enable them in the configuration file. Note that this only works if you have set up certificate files in Privoxy. However, I tend to avoid this approach as it overloads the server. That is, this will only work if the connection does not use "https".

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