#!/usr/bin/env sh

echo "CentOS 7:"
echo "yum install epel-release -y"
echo "yum install libsodium -y"
echo ""

echo "Ubuntu 16:"
echo "sudo apt install libsodium-dev"

echo "Install SS:"
echo "pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U"

sudo ssserver --user nobody -d start -p 443 -k password -m chacha20-ietf-poly1305
