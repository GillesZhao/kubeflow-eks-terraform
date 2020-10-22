#!/bin/bash


#Before to destroy this terraform stack, delete AWS NLB and ingress
kubectl delete -f deploy-ingress-nginx.yaml

echo 0
