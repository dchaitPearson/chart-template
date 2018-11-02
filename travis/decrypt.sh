#!/usr/bin/env bash

# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

set -e
set -x
# Decrypt AWS Credentials
mkdir ~/.aws
openssl aes-256-cbc -K $encrypted_4b5208cb190e_key -iv $encrypted_4b5208cb190e_iv -in credentials.enc -out credentials -d
