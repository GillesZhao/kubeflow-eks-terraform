# kubeflow-eks-terraform

Deploy kubeflow on AWS EKS with terraform

## Install Terraform opensource binary:
Get the terraform zip package from website : https://www.terraform.io/downloads.html

### For Linux platform:
```
     wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip
     unzip terraform_0.13.4_linux_amd64.zip
     mv ./terraform /usr/local/bin/
```

## Run terraform and start build resources on AWS:
Quick step:
```
    
    terraform init
    terraform apply
```

### Some information about the terraform stack:  
The stack will create:
```
     VPC
     Public and private subnet
     Nat gateway
     Internet gateway
     EKS cluster
     EKS node groups with EC2 worker nodes
     Autoscaling groups for EC2 worker nodes
```
