#!/bin/sh

sudo yum update -y
sudo yum upgrade -y
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager -y \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker


sudo docker rm --force postgres || true

sudo docker run -d \
  --name postgres \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin \
  -e POSTGRES_DB=sample \
  -p 80:5432 \
  -p 5432:5432 \
  --restart always \
  postgres:9.6.8-alpine


