#! /bin/bash

# modify the source of apt
cd /etc/apt
# cp sources.list sources.list.bak
echo "modify the source of apt from default to tuna"
read -p "version code(bionic):" version_code
if [ "${version_code}"="" ]; then
 version_code="bionic"
fi

cat>sources.list<<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code} main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code} main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${version_code}-security main restricted universe multiverse
EOF

# modify source of pip
echo "modify source of pip"
cd ~
mkdir ".pip"
cat>.pip/pip.conf<<EOF
[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple
EOF
