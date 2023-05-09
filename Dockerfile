# ビルド用ステージ
FROM ubuntu:22.04 as builder

ARG IMAGE_TAG="4.38.9760"

# TODO: ローカルビルド用に追加したオプションなのでmarge前に消す
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.naist.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    wget curl build-essential make

ADD https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz .
RUN tar xvf softether-vpnserver* \
    && cd vpnserver \
    && make

# 実行用ファイルを保存するステージ
FROM ubuntu:22.04
COPY --from=builder /vpnserver /usr/local/vpnserver

RUN cd /usr/local/vpnserver \
    && chmod 600 * \
    && chmod 700 vpncmd \
    && chmod 700 vpnserver
RUN apt-get update && apt-get install -y \
    iptables \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# IPフォワーディングの有効化
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# NAT設定スクリプトの追加
COPY setup-nat.sh /setup-nat.sh
RUN chmod +x /setup-nat.sh

# 起動スクリプトの追加
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
