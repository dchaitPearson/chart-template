#!/bin/bash

export CONTEXT=mac
export PIPELINE=local

travis/start_minikube_mac.sh
eval $(minikube docker-env)

travis/script/copy_chart.sh
travis/build_testimage.sh
make
eval $(minikube docker-env -u)