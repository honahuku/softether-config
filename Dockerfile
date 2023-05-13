# ビルド用ステージ
FROM ubuntu:22.04 as builder

ARG IMAGE_TAG="4.38.9760"

# TODO: ローカルビルド用に追加したオプションなのでmarge前に消す
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.naist.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list

RUN apt-get update --fix-missing && apt-get install -y \
    wget curl build-essential make

ADD https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz .
RUN tar xvf softether-vpnserver* \
    && cd vpnserver \
    && make

# 実行用ファイルを保存するステージ
FROM ubuntu:22.04
COPY --from=builder /vpnserver /usr/local/vpnserver
ENV SERVER_PASS="xxxx"

RUN cd /usr/local/vpnserver \
    && chmod 600 * \
    && chmod 700 vpncmd \
    && chmod 700 vpnserver

# TODO: ローカルビルド用に追加したオプションなのでmarge前に消す
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.naist.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list
RUN apt-get update --fix-missing && apt-get install -y \
    iproute2 iputils-ping net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 443/tcp 992/tcp 5555/tcp

# 起動スクリプトの追加
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
