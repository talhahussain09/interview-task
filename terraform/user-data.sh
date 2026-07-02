#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get install -y \
  docker.io \
  unzip \
  curl \
  wget

systemctl enable docker
systemctl start docker

if id -u ubuntu >/dev/null 2>&1; then
  usermod -aG docker ubuntu
fi

docker --version

cat > /home/ubuntu/server-ready.txt <<EOF
EC2 instance is ready.
Docker has been installed successfully.
This server is managed by Terraform.
EOF

chown ubuntu:ubuntu /home/ubuntu/server-ready.txt