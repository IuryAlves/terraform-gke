#!/usr/bin/env sh

set -e

source $(dirname $0)/common.sh

terraform -chdir=terraform apply -auto-approve 

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Creating kubernetes resources"

envsubst < kubernetes/pub-sub-subscription.yaml | kubectl apply -f-
envsubst < kubernetes/pub-sub-topic.yaml | kubectl apply -f-
envsubst < kubernetes/namespace.yaml | kubectl apply -f-
envsubst < kubernetes/config-connector.yaml | kubectl apply -f-
