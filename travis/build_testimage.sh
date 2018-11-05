#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.
set -e


CHART_NAME=$(travis/script/get_chartname.sh)

if [ $PIPELINE == "local" ]
then
  echo "image pushing not required"
  docker build tests -t chart-${CHART_NAME}/${CHART_NAME}-test:latest

else
  
  repocount=$(aws ecr describe-repositories --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE} --repository-names chart-${CHART_NAME}/${CHART_NAME}-test | grep -i repositoryArn | wc -l)

  if [ $repocount == 0 ]
  then
    echo "creating ecr repository"
    aws ecr create-repository --repository-name chart-${CHART_NAME}/${CHART_NAME}-test --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE}
  fi

  docker build tests -t ${ECR_AWS_ACC_NUM}.dkr.ecr.us-east-1.amazonaws.com/chart-${CHART_NAME}/${CHART_NAME}-test:latest
  docker push ${ECR_AWS_ACC_NUM}.dkr.ecr.us-east-1.amazonaws.com/chart-${CHART_NAME}/${CHART_NAME}-test:latest
fi