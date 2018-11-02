#!/usr/bin/env bash

# WARNING: This file is deployed from template. Raise a pull request against ansible-template to change.

set -e
set -x
# Decrypt AWS Credentials
mkdir ~/.aws
openssl aes-256-cbc -K $encrypted_53ac76c27cba_key -iv $encrypted_53ac76c27cba_iv -in credentials.enc -out credentials -d
