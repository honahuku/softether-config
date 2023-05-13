#!/usr/bin/env bash

/usr/local/vpnserver/vpnserver start
sleep 2
# サーバーパスワードの設定
/usr/local/vpnserver/vpncmd /SERVER localhost /cmd ServerPasswordSet "$SERVER_PASS"
# 匿名ユーザーへの列挙の禁止
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd SetEnumDeny
# SecureNATの有効化
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd SecureNatEnable
# SecureNATのNAT機能の有効化
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd NatEnable
# SecureNATのDHCP機能の有効化
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd DhcpEnable

# SecureNATのネットワークインターフェース設定の変更
# クラスA、/14のネットワークとする
# https://www.mrl.co.jp/download/manual-online/gl2000/gl2000_02/manual/docs/netlista.htm#list
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd SecureNatHostSet /MAC:none /IP:10.200.0.1 /MASK:255.252.0.0
# SecureNATのDHCP設定
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd DhcpSet /START:10.200.0.2 /END:10.203.255.255 /MASK:255.252.0.0 /EXPIRE:86400 /GW:10.200.0.1 /DNS:1.1.1.1 /DNS2:8.8.8.8 /DOMAIN:none /LOG:yes

# ユーザーの作成
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd UserCreate honahuku /GROUP:none /REALNAME:none /NOTE:none
# 認証方式を匿名認証に設定
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd UserAnonymousSet honahuku
