#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

set -e
set -x

eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa

CHART_NAME=$(travis/script/get_chartname.sh)
CHART_VERSION=1.0.0

# Tag Github repo with version prefix from version.txt and semver patch + 1
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
prefix=$CHART_VERSION
latest_tag=$(git ls-remote --tags origin | cut -f 3 -d '/' | grep "^${prefix}" | sort -t. -k 3,3nr | head -1)
if [ -z ${latest_tag} ]; then
  VERSION_TAG="${prefix}"
else
  VERSION_TAG="${latest_tag%.*}.$((${latest_tag##*.}+1))"
fi
git tag ${VERSION_TAG}
git push --tags


helm plugin install https://github.com/hypnoglow/helm-s3.git
AWS_DEFAULT_REGION=us-west-2 helm repo add s3repo s3://bitesize-helm-registry/charts
helm package $CHART_NAME --version $VERSION_TAG
AWS_DEFAULT_REGION=us-west-2 helm s3 push ${CHART_NAME}-${VERSION_TAG}.tgz s3repo