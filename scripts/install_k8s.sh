#!/bin/bash
sudo apt update -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# install docker
sudo apt install -y docker.io

# install k8s
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
sudo kubeadm version
sudo swapoff -a

# run docker through systemd
sudo echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' >> /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker

# install linkerd
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh
sudo echo 'export PATH=$PATH:$HOME/.linkerd/bin' >> ~/.bashrc
source ~/.bashrc

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
./get_helm.sh
