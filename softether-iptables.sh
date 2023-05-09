#!/bin/bash
TAP_ADDR=192.168.30.1
TAP_INTERFACE=tap_soft
VPN_SUBNET=192.168.30.0/24
NET_INTERFACE=enp1s0
VPNEXTERNALIP=$(curl globalip.me)

iptables -F && iptables -X
/sbin/ifconfig $TAP_INTERFACE $TAP_ADDR

iptables -t nat -A POSTROUTING -s $VPN_SUBNET -j SNAT --to-source $VPNEXTERNALIP

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -s $VPN_SUBNET -m state --state NEW -j ACCEPT
iptables -A OUTPUT -s $VPN_SUBNET -m state --state NEW -j ACCEPT
iptables -A FORWARD -s $VPN_SUBNET -m state --state NEW -j ACCEPT