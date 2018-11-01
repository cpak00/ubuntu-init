#! /bin/bash

# init
c_dir=$(cd `dirname $0`; pwd)
echo "current directory: ${c_dir}"

. $c_dir/dependencies/bash-init.sh

# modify source from default to tsinghua
sudo bash $c_dir/dependencies/modify-src.sh

# update apt-get
info "update apt-get"
echo `sudo apt-get update`
echo `sudo apt-get install aptitude`
info "finished"

# python3 install
info "install python3"
echo `sudo apt-get install python3 -y`
echo `sudo apt-get install python3-pip -y`
echo `sudo pip3 install setuptools`
info "finished"

# install shadowsocks client
info "install shadowsocks client"
echo `sudo apt-get install shadowsocks-libev -y`
info "finished"

# config shadowsocks
sudo bash $c_dir/dependencies/ss-conf.sh

# neccesary tool
echo `sudo apt-get install curl`

# auto remove
info "autoremove apt-get"
echo `sudo apt-get autoremove -y`
info "finished"