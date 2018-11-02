#! /bin/bash

# init
c_dir=$(cd `dirname $0`; pwd)
echo "current directory: ${c_dir}"

. $c_dir/dependencies/bash-init.sh

# modify source from default to tsinghua
sudo bash $c_dir/dependencies/modify-src.sh

# update apt-get
info "update apt-get -y"
echo `sudo apt-get update -y`
echo `sudo apt-get install aptitude -y`
info "finished"

# python3 install
info "install python3"
echo `sudo apt-get install python3 -y`
echo `sudo apt-get install python3-pip -y`
echo `sudo pip3 install setuptools -y`
info "finished"

# install shadowsocks client
info "install shadowsocks client"
echo `sudo apt-get install shadowsocks-libev -y`
info "finished"

# config shadowsocks
sudo bash $c_dir/dependencies/ss-conf.sh

# neccesary tool
echo `sudo apt-get install curl -y`
echo `sudo apt-get install net-tools -y`
echo `sudo apt-get install gnome-tweak-tool -y`
echo `sudo apt-get install chrome-gnome-shell -y`

# auto remove
info "autoremove apt-get"
echo `sudo apt-get autoremove -y`
info "finished"
