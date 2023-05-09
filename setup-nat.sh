#!/bin/sh
IFACE=$(ip route | grep default | awk '{print $5}')
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o $IFACE -j MASQUERADE
