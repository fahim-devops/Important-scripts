#!/bin/sh

#Get credentials for your cluster
gcloud container clusters get-credentials cluster-1 --zone=us-central1-c --project=ar

#Create a Kubernetes service account for your application to use. You can also use the default Kubernetes service account in the default or any existing namespace
kubectl create serviceaccount sw-gke-wi --namespace arc-sproutward-datahub-self-service-shared

#Allow the Kubernetes service account to impersonate the IAM service account by adding an IAM policy binding between the two service accounts. This binding allows the Kubernetes service account to act as the IAM service account.
gcloud iam service-accounts add-iam-policy-binding terraform@-tf-admin.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "[arc-datahub-self-service-shared/sw-gke-wi]" \
    --project=

#Annotate the Kubernetes service account with the email address of the IAM service account.
kubectl annotate serviceaccount sw-gke-wi \
    --namespace arc--datahub-self-service-shared \
    iam.gke.io/gcp-service-account=terraform@-tf-admin.iam.gserviceaccount.com

#Update your Pod spec to schedule the workloads on nodes that use Workload Identity and to use the annotated Kubernetes service account.
kubectl patch deployment monitors--monitors --namespace arc--datahub-self-service-shared --patch-file ./services/monitors/patch.yml

#Get a shell on the pod
kubectl exec -it monitors--monitors-6bc446bc8f-qxvcd \
  --namespace arc--datahub-self-service-shared \
  -- /bin/sh

#Verify that the metdata server is reachable
curl -H "Metadata-Flavo

#View the DeploymentSpec
kubectl get deployment monitors--monitors --namespace arc--datahub-self-service-shared -o yaml