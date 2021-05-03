#!/usr/bin/env sh


source terraform/terraform.tfvars

export KUBECONFIG=./kubeconfig.yaml 
export project_id service_account_name
