# refer https://github.com/helm/helm/blob/master/docs/chart_tests.md for creating test images

FROM 602604727914.dkr.ecr.us-east-1.amazonaws.com/ansible-ami:latest

RUN yum update -y && yum install curl -y &&\
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.5.6/bin/linux/amd64/kubectl &&\
    chmod +x ./kubectl &&\
    mv ./kubectl /usr/local/bin/kubectl

COPY test.sh /app/