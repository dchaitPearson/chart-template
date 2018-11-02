#!/bin/bash

minikube start --vm-driver=hyperkit \
--cpus 4 --memory 4096 \
--kubernetes-version v1.10.9 \
--apiserver-name=ansible-kube-master.localstack.local.dev \
--extra-config="apiserver.authorization-mode=RBAC" \
--extra-config="apiserver.service-cluster-ip-range=10.96.0.0/16" \
--extra-config="kubelet.pod-cidr=10.96.0.0/16" \
--extra-config="controller-manager.cluster-cidr=10.96.0.0/16"

source $(pwd)/travis/ecr/minikube-login.sh

minikube addons disable kube-dns
minikube addons disable coredns
minikube addons disable dashboard
minikube addons disable storage-provisioner
minikube addons disable nvidia-driver-installer
minikube addons disable nvidia-gpu-device-plugin
minikube addons disable default-storageclass
minikube addons disable addon-manager
minikube addons list

export MINIKUBE_IP=$(minikube ip)
sed "s/%%IP_ADDRESS%%/${MINIKUBE_IP}/g" $(pwd)/travis/kube/config_mac.tpl > $(pwd)/travis/kube/config_mac
sed "s/%%MINIKUBE_IP%%/${MINIKUBE_IP}/g" $(pwd)/travis/kube/config_mac_env_vars.sh.tpl > $(pwd)/travis/kube/config_mac_env_vars.sh
chmod +x $(pwd)/travis/kube/config_mac_env_vars.sh
sleep 10

echo "kubectl label nodes --all role=minion"
kubectl label nodes --all role=minion
echo "kubectl get nodes --show-labels"
kubectl get nodes --show-labels
# temp fix for kubernetes 1.10 with minikube
echo "kubectl delete deployment kube-dns -n kube-system"
kubectl delete deployment kube-dns -n kube-system
export CONTEXT=mac