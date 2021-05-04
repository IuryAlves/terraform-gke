#!/usr/bin/env sh

source $(dirname $0)/common.sh

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Removing kubernetes resources"

envsubst < kubernetes/pub-sub-topic.yaml | kubectl delete -f-
envsubst < kubernetes/pub-sub-subscription.yaml | kubectl delete -f-

terraform -chdir=terraform destroy -auto-approve

