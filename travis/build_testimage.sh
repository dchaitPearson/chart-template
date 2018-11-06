#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.
set -e


CHART_NAME=$(travis/script/get_chartname.sh)

if [ $PIPELINE == "local" ]
then
  echo "image pushing not required"
  eval $(aws ecr get-login --no-include-email --registry-ids 815492460363 --region=us-east-1)
  docker build tests -t chart-${CHART_NAME}/${CHART_NAME}-test:latest

else
  
  #create repo if not exist
  aws ecr describe-repositories --repository-names bitesize/chart-${CHART_NAME}-test --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE} || aws ecr create-repository --repository-name bitesize/chart-${CHART_NAME}-test  --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE}

  # Set repository access permissions
  aws ecr set-repository-policy --registry-id ${ECR_AWS_ACC_NUM} --repository-name bitesize/chart-${CHART_NAME}-test --policy-text "$(cat ${PWD}/travis/ecr/policies/ecr-repo-policy-cross-account-pull.json)" --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE}
  
  #login
  set +x
  eval $(aws ecr get-login --no-include-email --registry-ids ${ECR_AWS_ACC_NUM} --region=${ECR_AWS_REGION} --profile=${ECR_AWS_ACC_PROFILE})
  set -x
  
  docker build tests -t ${ECR_AWS_ACC_NUM}.dkr.ecr.us-east-1.amazonaws.com/bitesize/chart-${CHART_NAME}-test:latest
  docker push ${ECR_AWS_ACC_NUM}.dkr.ecr.us-east-1.amazonaws.com/bitesize/chart-${CHART_NAME}-test:latest
fi