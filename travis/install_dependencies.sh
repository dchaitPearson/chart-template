#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

set -e


inspec_version="1.41.0"
rocker_version="1.3.1"
jq_version="1.5"
minikube_version="v0.30.0"
kubectl_version="v1.10.9"
helm_version="v2.9.1"

inspec_pkg="inspec_${inspec_version}-1_amd64.deb"
rocker_pkg="rocker-${rocker_version}-linux_amd64.tar.gz"
helm_pkg="helm-${helm_version}-linux-amd64.tar.gz"

inspec_install_url="https://packages.chef.io/files/stable/inspec/${inspec_version}/ubuntu/14.04/${inspec_pkg}"
rocker_install_url="https://github.com/grammarly/rocker/releases/download/${rocker_version}/${rocker_pkg}"
jq_install_url="https://github.com/stedolan/jq/releases/download/jq-${jq_version}/jq-linux64"
kubectl_install_url="https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl"
minikube_install_url="https://storage.googleapis.com/minikube/releases/${minikube_version}/minikube-linux-amd64"
helm_install_url="https://storage.googleapis.com/kubernetes-helm/helm-${helm_version}-linux-amd64.tar.gz"


wget ${inspec_install_url} && sudo dpkg -i ${inspec_pkg}
wget ${rocker_install_url} && tar -xzf ${rocker_pkg} && mv rocker /home/travis/bin/rocker && chmod +x /home/travis/bin/rocker
wget ${jq_install_url} -O /home/travis/bin/jq && chmod +x /home/travis/bin/jq
wget ${kubectl_install_url} -O /home/travis/bin/kubectl && chmod +x /home/travis/bin/kubectl
wget ${minikube_install_url} -O /home/travis/bin/minikube && chmod +x /home/travis/bin/minikube
wget ${helm_install_url} && tar -zxf ${helm_pkg} && mv linux-amd64/helm /home/travis/bin/helm && chmod +x /home/travis/bin/helm

#pip install ansible awscli
pip install awscli

#install nsenter
docker run -v /usr/local/bin:/target jpetazzo/nsenter

# Pull down a key from AWS for checkout out Github repos
aws ssm get-parameters --names "github_rw_key" --region eu-west-1 --with-decryption | jq -r ".Parameters[0].Value" > ~/.ssh/id_rsa
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
