# 部署脚本

## install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

## start docker
systemctl start docker

## install: node, mysql, git, pm2, nvm

## install mysql docker image
docker pull mysql:5.7.22

## mysql 配置

## install node related
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nodejs
npm install -g pm2

## install git
yum install -y git

## auto keygen
ssh-keygen -t rsa -N "" -f ~/.ssh/ainit
ssh-copy-id -i ~/.ssh/ainit.pub []

## git pull origin code
