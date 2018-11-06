#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

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
travis/minikube_custom.sh