#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

if [ -z "${AWS_PROFILE}" ] || [ "${AWS_PROFILE}" == '' ]; then
  ECR_AWS_PROFILE="default"
else
  ECR_AWS_PROFILE="${AWS_PROFILE}"
fi

echo "AWS PROFILE: ${ECR_AWS_PROFILE}"
ECR_LOGIN_STRING=$(aws ecr get-login --no-include-email --registry-ids 815492460363 --region=us-east-1 --profile=${ECR_AWS_PROFILE})

if [ -z "${TRAVIS_BUILD_DIR}" ] || [ "${TRAVIS_BUILD_DIR}" == '' ]; then
  minikube ssh "${ECR_LOGIN_STRING}"
  minikube ssh "sudo cp ~/.docker/config.json /var/lib/kubelet/"
  minikube ssh "sudo systemctl restart kubelet"
else
  eval "${ECR_LOGIN_STRING}"
  sudo cp ~/.docker/config.json /var/lib/kubelet/
  sudo systemctl restart kubelet
fi