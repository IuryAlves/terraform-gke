#!/usr/bin/env sh

set -e 

source terraform/terraform.tfvars

export KUBECONFIG=./kubeconfig.yaml

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Removing kubernetes resources"

for file in kubernetes/*.yaml; do
  envsubst < $file | kubectl apply -f-
done

terraform -chdir=terraform destroy -auto-approve

