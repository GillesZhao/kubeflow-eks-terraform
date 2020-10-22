#!/bin/bash


#Before to destroy this terraform stack, delete AWS NLB and ingress
helm uninstall ingress-nginx

echo 0
