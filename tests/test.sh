#!/bin/bash

#test steps goes here(can use any testing framework)
kubectl get pods -n kube-system

svcip=$(kubectl get svc kube-dns -n kube-system -o json | jq .spec.clusterIP)

if [ $svcip = '"10.0.0.2"' ]; then
  echo "svc-ip test : PASS"
else
  echo "svc-ip tests : FAIL"
  exit 1
fi