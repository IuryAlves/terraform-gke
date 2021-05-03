# Google Kubernetes Engine with Terraform and Kubernetes Config Connector

This project uses Terraform and Kubernetes Config Connector for creating and configuring a Kubernetes cluster on Google Cloud.

* Terraform is used for creating the cluster, adding nodes and configuring a service account.
* KCC is used for creating [Pub/Sub](https://cloud.google.com/pubsub/docs) topics and subscriptions.


## Installing

* [Install Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [Install Terraform](https://www.terraform.io/downloads.html)


## Configuring

* Fill in the info for your Google project under `terraform/terraform.tfvars`
* Copy your service account credentials to `terraform/google-creds.json`
* Authenticate in gcloud: `gcloud auth login`

## Running


### Creating
```
terraform -chdir=terraform init
./create.sh
```

### Destroying

```
./destroy.sh
```
