#!/usr/bin/env sh

set -e

source $(dirname $0)/common.sh

terraform -chdir=terraform apply -auto-approve 

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Creating kubernetes resources ..."


envsubst < kubernetes/config-connector.yaml | kubectl apply -f-

echo "Waiting for config-connector to be ready ..."

kubectl wait \
    crd/configconnectors.core.cnrm.cloud.google.com \
    --timeout=60s \
    --for condition=established

sleep 30

envsubst < kubernetes/namespace.yaml | kubectl apply -f-
envsubst < kubernetes/enable-pubsub.yaml | kubectl apply -f-
envsubst < kubernetes/pub-sub-topic.yaml | kubectl apply -f-
envsubst < kubernetes/pub-sub-subscription.yaml | kubectl apply -f-
