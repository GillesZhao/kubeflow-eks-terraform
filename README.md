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
   Quick start:
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

## After EKS cluster created by terraform, kubeflow building will be launched: 
   Once the EKS cluster is ready, terraform will trigger local scripts to fetch kubeflow codes and deploy it into EKS:
```
    resource "null_resource" "deploy_kubeflow" {

      depends_on = [
        module.eks
      ]

      provisioner "local-exec" {
        command = "aws --region ${var.region} eks update-kubeconfig --name ${local.cluster_name}"
      }

      provisioner "local-exec" {
        command = "sh deploy_kubeflow.sh"
      }

    }
```
### Information in the script deploy_kubeflow.sh:
   Prepare the environment:
```
    Install kubectl
    Install kfctl
    Get and apply kubeflow deployment codes
    Create Network Load Balancer(NLB) on AWS
    Create ingress in istio namespace
```

## Some points to pay attention:
   SSL certificate and Route 53 records pointing to NLB need to be handled manually.