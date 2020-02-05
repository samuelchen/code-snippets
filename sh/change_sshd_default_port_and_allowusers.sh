#!/usr/local/env sh

PORT="1234"

sudo sed -i "s/#Port 22/Port ${PORT}/g" /etc/ssh/sshd_config

echo ""|sudo tee -a /etc/ssh/sshd_config
echo "AllowUsers  samuel"|sudo tee -a /etc/ssh/sshd_config
echo ""|sudo tee -a /etc/ssh/sshd_config

sudo systemctl restart sshd
