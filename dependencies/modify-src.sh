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
mkdir -p ".pip"
cat>.pip/pip.conf<<EOF
[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple
EOF

# modify jdk path
echo "modify jdk path"
read -p "JAVA_HOME:" java_path
cat>>~/.bashrc<<EOF

# java path
export JAVA_HOME=$java_path
export JRE_HOME=$java_path/jre
export CLASSPATH=.:\$JAVA_HOME/lib:\$JRE_HOME/lib
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
