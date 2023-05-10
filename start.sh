#!/usr/bin/env bash
SERVER_PASS=xxx
HUB_PASS=yyy

/usr/local/vpnserver/vpnserver start
sleep 2
/usr/local/vpnserver/vpncmd /SERVER localhost /cmd ServerPasswordSet $SERVER_PASS
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd SetEnumDeny
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd SecureNatEnable
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd NatEnable
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd DhcpEnable

# クラスA、/14のネットワークとする
# https://www.mrl.co.jp/download/manual-online/gl2000/gl2000_02/manual/docs/netlista.htm#list
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd SecureNatHostSet /MAC:none /IP:10.200.0.1 /MASK:255.252.0.0
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD $SERVER_PASS /HUB:DEFAULT /cmd DhcpSet /START:10.200.0.2 /END:10.203.255.255 /MASK:255.252.0.0 /EXPIRE:86400 /GW:10.200.0.1 /DNS:1.1.1.1 /DNS2:8.8.8.8 /DOMAIN:none /LOG:yes
