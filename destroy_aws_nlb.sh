!/bin/bash


#Before to destroy this terraform stack, delete AWS NLB and ingress
kubectl create -f deploy-ingress-nginx.yaml
