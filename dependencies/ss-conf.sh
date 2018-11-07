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
        sudo ss-local -c $filepath -f /etc/shadowsocks.pid
        ;;
    stop)
        killall ss-local
        ;;
    restart)
        killall ss-local
        sudo ss-local -c $filepath -f /etc/shadowsocks.pid
        ;;
esac
EOF
sudo chmod +x $bin_loc

# config git
cat>~/.gitconfig<<EOF
[http]
        proxy = socks5://$local_ip:$local_port
[https]
        proxy = socks5://$local_ip:$local_port
EOF

# create systemctl
cat>/etc/systemd/system/shadowsocks.service<<EOF
[Unit]
Description=shadowsocks
After=network.target
[Service]
Type=forking
PIDFile=/etc/shadowsocks.pid
ExecStart=/bin/bash /bin/shadowsocks start
ExecStop=/bin/bash /bin/shadowsocks stop
ExecReload=/bin/bash bin/shadowsocks restart
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF

echo `sudo chmod 754 /etc/systemd/system/shadowsocks.service`
echo `sudo systemctl enable shadowsocks`
echo `sudo service shadowsocks start`
echo "service shadowsocks create and start"

echo "finished"
