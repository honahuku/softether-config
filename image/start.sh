#!/usr/bin/env bash
set -e

# kube-dnsのIPアドレスを取得
KUBE_DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
# レコードが空かどうかチェック
if [ "$KUBE_DNS" = "" ]; then
    echo "Failed to get DNS record."
    exit 1
fi

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
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd DhcpSet /START:10.200.0.2 /END:10.203.255.255 /MASK:255.252.0.0 /EXPIRE:86400 /GW:10.200.0.1 /DNS:"$KUBE_DNS" /DNS2:1.1.1.1 /DOMAIN:none /LOG:yes

# ユーザーの作成
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd UserCreate honahuku /GROUP:none /REALNAME:none /NOTE:none
# 認証方式を匿名認証に設定
/usr/local/vpnserver/vpncmd /SERVER localhost /PASSWORD "$SERVER_PASS" /HUB:DEFAULT /cmd UserAnonymousSet honahuku

# 終了処理としてシグナルトラップを設定
trap '/usr/local/vpnserver/vpnserver stop; exit' SIGTERM

# 無限ループを作成し、コンテナが動作し続けるようにする
while true; do sleep 1; done
