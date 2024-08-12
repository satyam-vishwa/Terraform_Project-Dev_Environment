#Remove if any previous version already installed
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

#Set up the docker repository
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Install Docker engine
sudo yum install docker-ce docker-ce-cli containerd.io

#Start Docker
sudo systemctl start docker

#Enable docker to start at boot
sudo systemctl enable docker

#Verify Installation
docker --version