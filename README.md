# Requirements
In order to use this repo you will need installed:
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (I have tested this configuration using Terraform 0.13)
- [GCloud CLI](https://cloud.google.com/sdk/docs/quickstart)

Once you have the GCloud CLI installed, we will need to enable some APIs that the service account that Terraform will use will need:

```bash
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
```

Then we will need to first enable the  you will also need to create a service account in GCP that is going to be the responsible for creating the cluster:

```bash
gcloud iam service-accounts create {service_account_name}
```

Once the service account has been created, we'll need to give it some permissions:
```bash

gcloud projects add-iam-policy-binding {project_name} --member serviceAccount:{service_account_name}@{project_name}.iam.gserviceaccount.com --role roles/container.admin
gcloud projects add-iam-policy-binding {project_name} --member serviceAccount:{service_account_name}@{project_name}.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding {project_name} --member serviceAccount:{service_account_name}@{project_name}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding {project_name} --member serviceAccount:{service_account_name}@{project_name}.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
```
After this, we will need to retrieve the service account keyfile that we are going to be using to authenticate with GCP. For that run:

```bash
gcloud iam service-accounts keys create terraform-gke-keyfile.json --iam-account={service_account_name}@{project_name}.iam.gserviceaccount.com
```
This is going to generate a `terraform-gke-keyfile.json` file that we will pass to the terraform configuration through the `credentials` variable in the [variables.auto.tfvars)](https://github.com/davilag/traefik-k8s-gcp/blob/master/variables.auto.tfvars). You will also need to populate the `service_account` variable on the same file with `{service_account_name}@{project_name}.iam.gserviceaccount.com`.

**NOTE:** Do not push this file to any repository as it will give you access to GCP!

# Create cluster

Once all has been set, you just need to run:
```bash
terraform init
```
This will download the different Terraform providers needed to create the resources in GCP. To see the resources that are going to be created:
```bash
terraform plan
```
And finally, to create the resources:
```bash
terraform apply
```
If multiple people are going to use the same repo to create the same resources, the usage of [Terraform Cloud](https://www.terraform.io/docs/cloud/index.html) is recommended.