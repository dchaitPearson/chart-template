#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

set -e

aws ssm get-parameters --names "github_rw_key" --region eu-west-1 --with-decryption | jq -r ".Parameters[0].Value" > ~/.ssh/id_rsa
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
chmod 600 ~/.ssh/id_rsa && eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
