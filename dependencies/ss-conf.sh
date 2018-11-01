#! /bin/bash

# create shadowsocks configure file
echo "create shadowsocks configure file"
read -p "server's ip:" ip
read -p "server's port:" port
echo "local's ip:0.0.0.0"
local_ip="0.0.0.0"
echo "local's port:1080"
local_port="1080"
read -s -p  "password:" password
echo "timeout:500"
timeout="500"
read -p "method(aes-256-cfb)" method
if [ "$method" = "" ]; then
 method="aes-256-cfb"
fi

read -p "in /etc? (Y/n):" is_etc
cd ~
filepath="shadowsocks.json"
if [ "$is_etc" = "y" -o "$is_etc" = "Y" ]; then
 echo "create shadowsocks configure file in /etc/"
 filepath="/etc/shadowsocks.json"
else
 echo "create shadowsocks configure file in current directory"
fi

cat>${filepath}<<EOF
{
 "server": "$ip",
 "server_port": $port,
 "local_address": "$local_ip",
 "local_port": $local_port,
 "password": "$password",
 "timeout": $timeout,
 "method": "$method"
}
EOF

bin_loc="/bin/shadowsocks"
cat>$bin_loc<<EOF
#! /bin/bash
case \$1 in
    start)
        ss-redir -c $filepath -f /etc/shadowsocks.pid
        ;;
    stop)
        kill -9 `cat /etc/shadowsocks.pid`
        ;;
    restart)
        kill -9 /etc/shadowsocks.pid
        ss-redir -c $filepath -f /etc/shadowsocks.pid
        ;;
esac
EOF
sudo chmod +x $bin_loc

echo "install iptables-persistent"
echo `sudo apt-get install iptables-persistent -y`

# configure nat rules
echo "iptables config"
echo "create chain: shadowsocks"
read -p "please ensure iptables.nat.SHADOWSOCKS has been deleted"
iptables -t nat -N SHADOWSOCKS

iptables -t nat -A SHADOWSOCKS -p tcp --dport $port -j RETURN

iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports $local_port

echo "inject shadowsocks before output"
iptables -t nat -I OUTPUT -p tcp -j SHADOWSOCKS

echo "iptables config completed"

echo "iptables rules save"
echo `sudo service iptables-persistent save`

echo "finished"
