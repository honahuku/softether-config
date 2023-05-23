#!/usr/bin/env bash
set -e

nic=$(ip route | grep default | awk '{print $5}')
ip route add 10.96.0.0/12 dev ${nic}

# kube-dnsのIPアドレスを取得
KUBE_DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
# レコードが空かどうかチェック
if [ "$KUBE_DNS" = "" ]; then
    echo "Failed to get DNS record."
    exit 1
fi

/usr/local/vpnserver/vpnserver start
sleep 2

# ローカルブリッジ接続の作成
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /cmd BridgeCreate DEFAULT /DEVICE:soft /TAP:yes

# # 匿名ユーザーへの列挙の禁止
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd SetEnumDeny
# # SecureNATの有効化
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd SecureNatEnable
# # SecureNATのNAT機能の有効化
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd NatEnable
# # SecureNATのDHCP機能の有効化
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd DhcpEnable

# # SecureNATのネットワークインターフェース設定の変更
# # クラスA、/14のネットワークとする
# # https://www.mrl.co.jp/download/manual-online/gl2000/gl2000_02/manual/docs/netlista.htm#list
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd SecureNatHostSet /MAC:none /IP:10.200.0.1 /MASK:255.252.0.0
# # SecureNATのDHCP設定
# /usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd DhcpSet /START:10.200.0.2 /END:10.203.255.255 /MASK:255.252.0.0 /EXPIRE:86400 /GW:10.200.0.1 /DNS:"$KUBE_DNS" /DNS2:1.1.1.1 /DOMAIN:none /LOG:yes

# ユーザーの作成
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd UserCreate honahuku /GROUP:none /REALNAME:none /NOTE:none
# 認証方式を匿名認証に設定
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD /HUB:DEFAULT /cmd UserAnonymousSet honahuku

# サーバーパスワードの設定
/usr/local/vpnserver/vpncmd /SERVER localhost /cmd ServerPasswordSet "$SERVER_PASS"
