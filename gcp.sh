#!/bin/bash

gcloud auth configure-docker -y

docker pull kgrbovic/spring-petclinic
docker tag kgrbovic/spring-petclinic gcr.io/gd-gcp-internship-devops/spring-petclinic

docker push gcr.io/gd-gcp-internship-devops/spring-petclinic

gcloud compute networks create vpc-practicalgcp --project=gd-gcp-internship-devops --subnet-mode=auto --mtu=1460 --bgp-routing-mode=regional

gcloud compute firewall-rules create vpc-practicalgcp-allow-custom --project=gd-gcp-internship-devops --network=projects/gd-gcp-internship-devops/global/networks/vpc-practicalgcp --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.128.0.0/9 --action=ALLOW --rules=all

gcloud compute firewall-rules create vpc-practicalgcp-allow-icmp --project=gd-gcp-internship-devops --network=projects/gd-gcp-internship-devops/global/networks/vpc-practicalgcp --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp

gcloud compute firewall-rules create vpc-practicalgcp-allow-rdp --project=gd-gcp-internship-devops --network=projects/gd-gcp-internship-devops/global/networks/vpc-practicalgcp --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389

gcloud compute --project=gd-gcp-internship-devops firewall-rules create allowtcptraffic --direction=INGRESS --priority=1000 --network=vpc-practicalgcp --action=ALLOW --rules=tcp:22

gcloud compute instances create-with-container testinstance-gcppractical --project=gd-gcp-internship-devops --zone=europe-west1-b --machine-type=f1-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-practicalgcp --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=71936227901-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --image=projects/cos-cloud/global/images/cos-stable-109-17800-147-54 --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=testinstance-gcppractical --container-image=gcr.io/gd-gcp-internship-devops/spring-petclinic --container-restart-policy=always --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud,container-vm=cos-stable-109-17800-147-54

gcloud compute ssh --zone "europe-west1-b" "testinstance-gcppractical" --project "gd-gcp-internship-devops"

