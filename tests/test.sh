#!/bin/bash

#test steps goes here(can use any testing framework)
kubectl get pods -n kube-system

ns=$(kubectl get ns | grep -i test | wc -l)

if [ $ns = '1' ]; then
  echo "ns test : PASS"
else
  echo "ns test : FAIL"
  exit 1
fi