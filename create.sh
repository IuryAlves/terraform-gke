#!/usr/bin/env sh

set -e

source $(dirname $0)/common.sh

terraform -chdir=terraform apply -auto-approve 

gcloud auth activate-service-account  terraform@$project_id.iam.gserviceaccount.com \
    --key-file=terraform/google-creds.json \
    --project=$project_id

# Not possible to do with Terraform because google_project_iam_binding has a bug.
# See: https://github.com/hashicorp/terraform-provider-google/issues/9050
gcloud projects add-iam-policy-binding $project_id \
    --member="serviceAccount:$service_account_name@$project_id.iam.gserviceaccount.com" \
    --role="roles/owner"

gcloud container clusters get-credentials test-cluster \
    --project $project_id \
    --zone=$region

echo "Creating kubernetes resources"

envsubst < kubernetes/config-connector.yaml | kubectl apply -f-
envsubst < kubernetes/namespace.yaml | kubectl apply -f-
envsubst < kubernetes/enable-pubsub.yaml | kubectl apply -f-
envsubst < kubernetes/pub-sub-topic.yaml | kubectl apply -f-
envsubst < kubernetes/pub-sub-subscription.yaml | kubectl apply -f-
