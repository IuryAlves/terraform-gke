#!/usr/bin/env sh

set -e 

source $(dirname $0)/common.sh

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Removing kubernetes resources"

for file in kubernetes/*.yaml; do
  envsubst < $file | kubectl apply -f-
done

terraform -chdir=terraform destroy -auto-approve

