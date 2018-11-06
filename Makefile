# WARNING: This file is deployed from template. Raise a pull request against chart-template to change.

SHELL := /bin/bash
IMAGE := $(notdir $(CURDIR))
DOMAIN := .localstack.local
THIS_FILE := $(lastword $(MAKEFILE_LIST))

GITHUB_RO_KEY := $(shell aws ssm get-parameters --names "github_ro_key" --region eu-west-1 --with-decryption | jq ".Parameters[0].Value")
DOCKER_LOGIN := $(shell aws ecr get-login --no-include-email --region us-east-1)

CHART_NAME = $(shell travis/script/get_chartname.sh)
CHART_PACKAGE = "$(CHART_NAME)-1.0.0-dev.tgz"

ifneq ($(TRAVIS),)
    DOCKER_IP := $(shell ip addr show docker0 | grep 'inet\b' | awk '{print $$2}' | cut -d/ -f1)
    TRAVISOPTS := "--add-host=ansible-kube-master.localstack.local.dev:$(DOCKER_IP)"
else
    TRAVISOPTS =
endif

ifeq ($(CONTEXT),)
ifeq ($(TRAVIS),)
  	$(error "YOU MUST SET 'CONTEXT' ENVIRONMENT VARIABLE TO perform 'make' COMMANDS")
  	exit 1
else
    MOUNTKUBECONFIG = -e CONTEXT=travis -v $(TRAVIS_BUILD_DIR)/travis/kube:/root/.kube
		CONTEXT = travis
endif
else
    MOUNTKUBECONFIG := -v $(HOME)/.kube:/root/.kube -e CONTEXT=$(CONTEXT)

ifeq ($(CONTEXT),mac)
MOUNTKUBECONFIG += -v $(HOME)/.minikube:/root/.minikube
endif
ifeq ($(CONTEXT),minikube)
MOUNTKUBECONFIG += -v $(HOME)/.minikube:$(HOME)/.minikube
endif
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: build run config ## Runs build, run,config and test


build:  ## building helm chart
	@echo "Building Helm chart"
	@bash -c "helm init"
	sleep 30
	@bash -c "helm package $(CHART_NAME) --version 1.0.0-dev"



run:  ## run helm chart on minikube
	@echo "Deploying helm chart"
	@bash -c "helm install $(CURDIR)/$(CHART_PACKAGE) -n $(CHART_NAME) --namespace kube-system --set pipeline=$(PIPELINE)"


config:  ## test kubedns
	@echo "Running test cases"
	@bash -c "helm list"
	@bash -c "helm test $(CHART_NAME)"


.DEFAULT_GOAL := all
.PHONY: build run config 
