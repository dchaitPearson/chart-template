#!/bin/bash

sudo -E minikube addons disable kube-dns
sudo -E minikube addons disable coredns
sudo -E minikube addons disable dashboard
sudo -E minikube addons disable storage-provisioner
sudo -E minikube addons disable nvidia-driver-installer
sudo -E minikube addons disable nvidia-gpu-device-plugin
sudo -E minikube addons disable default-storageclass
sudo -E minikube addons disable addon-manager
sudo -E minikube addons list

echo "kubectl label nodes --all role=minion"
kubectl label nodes --all role=minion
echo "kubectl get nodes --show-labels"
kubectl get nodes --show-labels
# temp fix for kubernetes 1.10 with minikube
echo "kubectl delete deployment kube-dns -n kube-system"
kubectl delete deployment kube-dns -n kube-system
kubectl delete sa kube-dns -n kube-system
kubectl delete service kube-dns -n kube-system
kubectl delete clusterroles system:kube-dns -n kube-system
kubectl delete clusterrolebindings system:kube-dns -n kube-system