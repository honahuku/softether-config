#!/usr/bin/env bash
IFACE=$(ip route | grep default | awk '{print $5}')
nft add table ip nat
nft add chain ip nat POSTROUTING { type nat hook postrouting priority 100 \; }
nft add rule ip nat POSTROUTING oifname $IFACE ip saddr 192.168.0.0/24 masquerade
