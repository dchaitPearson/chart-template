#!/bin/bash

kubernetes_version=${1:-v1.10.9}

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir -p $HOME/.kube
touch $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

sudo -E minikube start --vm-driver=none \
        --cpus 2 --memory 4096 \
        --kubernetes-version=${kubernetes_version} \
        --feature-gates=CoreDNS=true \
        --apiserver-name=ansible-kube-master.localstack.local.dev \
        --extra-config="apiserver.authorization-mode=RBAC" \
        --extra-config="apiserver.service-cluster-ip-range=10.96.0.0/16" \
        --extra-config="kubelet.pod-cidr=10.96.0.0/16" \
        --extra-config="controller-manager.cluster-cidr=10.96.0.0/16"

minikube_started="false"

for i in {1..150} ; do
  kubectl get pods
  if [ $? -eq 0 ]; then
    minikube_started="true"
    break
  fi
  echo "waiting for minikube to start..."
  sleep 2
done

if [ "${minikube_started}" != "true" ]; then
    echo "ERROR: minikube could not start"
    exit 1
fi

sleep 10

source $(pwd)/travis/ecr/minikube-login.sh

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