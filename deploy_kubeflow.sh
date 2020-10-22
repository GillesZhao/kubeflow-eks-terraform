!/bin/bash

#install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#install kfctl
wget https://github.com/kubeflow/kubeflow/releases/download/v1.0/kfctl_v1.0-0-g94c35cf_linux.tar.gz
tar zxf kfctl_v1.0-0-g94c35cf_linux.tar.gz
chmod +x ./kfctl
sudo mv ./kfctl /usr/local/bin/kfctl
rm -f kfctl*.tar.gz

#get eks nodes info
/usr/local/bin/kubectl get nodes > get_eks_nodes_info.log 2>&1

#get kubeflow deployment codes
git clone https://github.com/kubeflow/manifests.git
cd manifests/kfdef/
kfctl apply -V -f kfctl_istio_dex.v1.0.2.yaml 

#once kubeflow deployed, create AWS NLB and ingress
cd ../..
kubectl create -f deploy-ingress-nginx.yaml 
sleep 600
kubectl create -f kubeflow-ingress.yaml


