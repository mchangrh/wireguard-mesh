#!/bin/sh
# 2022-11-20

# oneliner for setting up new machines
# curl -sSL https://raw.githubusercontent.com/mchangrh/wireguard-mesh/main/update.sh | bash

# cd to /etc/wireguard
cd /etc/wireguard || exit
# download new update.sh script and chmod +x 
wget -qN https://raw.githubusercontent.com/mchangrh/wireguard-mesh/main/update.sh && chmod +x update.sh
# download new mesh.conf
wget -qN https://raw.githubusercontent.com/mchangrh/wireguard-mesh/main/mesh.conf
# cat files together
cat head.conf mesh.conf > wg0.conf
# restart wg-quick through systemd or openrc
systemctl restart wg-quick@wg0 || rc-service wg-quick.wg0 restart
# ping host to test connectivity
ping 10.10.0.65 -c 1 -W 1