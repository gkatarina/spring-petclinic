#!/bin/bash

gcloud compute instances stop testinstance-gcppractical --project=gd-gcp-internship-devops --zone=europe-west1-b
gcloud compute instances delete testinstance-gcppractical
gcloud compute networks delete vpc-practicalgcp

# gcloud storage rm --recursive gs://BUCKET_NAME //bucket name may vary