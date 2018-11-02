#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.
set -e

eval $(aws ecr get-login --no-include-email --region us-east-1)
CHART_NAME=$(travis/script/get_chartname.sh)

repocount=$(aws ecr describe-repositories --region us-east-1 --repository-names chart-${CHART_NAME}/${CHART_NAME}-test | grep -i repositoryArn | wc -l)
echo $repocount
if [ $repocount == 0 ]
then
  echo "creating ecr repository"
  aws ecr create-repository --repository-name chart-${CHART_NAME}/${CHART_NAME}-test --region us-east-1
fi

docker build tests -t 815492460363.dkr.ecr.us-east-1.amazonaws.com/chart-${CHART_NAME}/${CHART_NAME}-test:latest

if [ $PIPELINE == "local" ]
then
  echo "image pushing not required"
else
  docker push 815492460363.dkr.ecr.us-east-1.amazonaws.com/chart-${CHART_NAME}/${CHART_NAME}-test:latest
fi  