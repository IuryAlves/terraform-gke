#!/usr/bin/env sh


source terraform/terraform.tfvars

export KUBECONFIG=./kubeconfig.yaml 
export GOOGLE_APPLICATION_CREDENTIALS=terraform/google-creds.json
export project_id service_account_name
