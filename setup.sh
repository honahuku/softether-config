#!/bin/bash -xe

mv /boot/grub/menu.lst /boot/grub/menu.lst.org
apt update
apt upgrade -y
apt install -y build-essential libssl-dev g++ openssl libpthread-stubs0-dev gcc-multilib dnsmasq dnsutils curl vim htop net-tools make
wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz
tar xvf softether-vpnserver*
cd vpnserver
make
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver
cd
\cp -r -f ./vpnserver/ /usr/local/
\rm -rf ./vpnserver
ls -lra /usr/local/vpnserver
rm -rf softether-vpnserver*
/usr/local/vpnserver/vpnserver start

# IPsec事前共有キー
echo 'ServerPasswordSet passwd' >>  /usr/local/vpnserver/batch.txt;
echo 'HubCreate vpnhub1 /PASSWORD:passwd' >>  /usr/local/vpnserver/batch.txt;
echo 'HubDelete DEFAULT' >>  /usr/local/vpnserver/batch.txt;
echo 'BridgeCreate vpnhub1 /DEVICE:soft /TAP:yes' >>  /usr/local/vpnserver/batch.txt;
echo 'Hub vpnhub1' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupCreate Admin /REALNAME:none /NOTE:none' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupCreate General /REALNAME:none /NOTE:none' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:NoRouting /VALUE:no' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:MaxConnection /VALUE:8' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:FixPassword /VALUE:yes' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:MultiLogins /VALUE:1' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:CheckIP /VALUE:yes' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:CheckMac /VALUE:yes' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:CheckIPv6 /VALUE:yes' >>  /usr/local/vpnserver/batch.txt;
echo 'GroupPolicySet General /NAME:AutoDisconnect /VALUE:86400' >>  /usr/local/vpnserver/batch.txt;
echo 'UserCreate admin /GROUP:Admin /NOTE:none /REALNAME:none' >>  /usr/local/vpnserver/batch.txt;
echo 'UserPasswordSet admin /password:passwd' >>  /usr/local/vpnserver/batch.txt;
sleep 5
/usr/local/vpnserver/vpncmd /server localhost /in:/usr/local/vpnserver/batch.txt
mv ./vpnserver.service /lib/systemd/system/
mv ./softether-iptables.sh /root/
chmod +x /root/softether-iptables.sh
mv /etc/dnsmasq.conf /etc/dnsmasq.conf-bak
mv ./dnsmasq.conf /etc/
mv /etc/sysctl.conf /etc/sysctl.conf-bak
mv ./sysctl.conf /etc/sysctl.conf
sysctl -f
systemctl enable vpnserver
systemctl enable dnsmasq
systemctl start dnsmasq
systemctl restart vpnserver
systemctl restart dnsmasq
iptables --list
# systemctl status dnsmasq
# systemctl status vpnserver
