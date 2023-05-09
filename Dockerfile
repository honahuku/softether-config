# ビルド用ステージ
FROM ubuntu:22.04 as builder

ARG IMAGE_TAG="4.38.9760"

RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.naist.jp/pub/Linux/ubuntu/%' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    wget curl build-essential make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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
