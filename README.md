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
    
    Add AWS credential before launching.
    The values like VPC name and IP scope, EKS Cluster name, node instance size etc. are defined in values.auto.tfvars
    Please edit it to specify the values, and they will be automatically applied by terraform.
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
     AWS Load Balancer integrated with ingress-nginx in EKS(Deployed by helm, please check detail in scripts/deploy_kubeflow.sh)
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
        command = "sh scripts/deploy_kubeflow.sh"
      }

    }
```
### What is in the script deploy_kubeflow.sh:
   Prepare the environment:
```
    Install kubectl
    Install kfctl
    Install helm
    Get and apply kubeflow deployment codes
    Create Network Load Balancer(NLB) integrated with ingress-nginx on AWS
    Create ingress in istio namespace
```

## Some points to pay attention:
1. SSL certificate and Route 53 records pointing to NLB need to be handled manually.

2. Host name is defined in kubeflow-ingress.yaml:
```
[...]
   spec:
     rules:
     - host: kubeflow.terraform.xxxxx.com         <---- Here's an example.
       http:
         paths:
         - backend:
             serviceName: istio-ingressgateway
             servicePort: 80
[...]
```
3. We may have an issue with IAM users that didn't initially create the EKS cluster, they always got error: You must be logged in to the server (Unauthorized) error when using kubectl (even though aws-iam-authenticator gave them some token).

   To get rid of this issue, we have some steps here:
   
    Install aws-iam-authenticator: 
   
    #curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator
    
    Add the blocks as below into $HOME/.kube/config      
```     
     e.g.
     #vi /root/.kube/config
     [...]
     - name: arn:aws:eks:us-east-1:xxxxxxxx:cluster/xxxxx
       user:
         exec:
           apiVersion: client.authentication.k8s.io/v1alpha1
           args:
           - token
           - -i
           - xxxxxx
           command: aws-iam-authenticator
     [...]
     
```
   
   Choose either of following methods to add IAM USER ARN into cluster ConfigMap aws-auth:
   
   a. Edit kubernetes configmap after cluster created:

      kubectl edit -n kube-system configmap/aws-auth

   b. Add value to variables "map_users" when apply this terraform stack:

    Here's an example:
```
    variable "manage_aws_auth" {
      description = "Whether to apply the aws-auth configmap file."
      default     = true                                           <---- Here must put "true"
    }  
     
    variable "map_users" {
      description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
      type = list(object({
        userarn  = string
        username = string
        groups   = list(string)
      }))
      
      default = [
        {
          userarn  = "arn:aws:iam::66666666666:user/user1"         <---- Put the iam user arn here
          username = "user1"
          groups   = ["system:masters"]
        },
        {
          userarn  = "arn:aws:iam::66666666666:user/user2"         <---- Put the iam user arn here
          username = "user2"
          groups   = ["system:masters"]
        },
      ]
    }
    
```

## Resources destroy:
```

   terraform destroy
   
   The local script will delete AWS Load Balancer first of all:
  
   provisioner "local-exec" {
     when    = destroy
     command = "sh scripts/destroy_aws_nlb.sh"
   }


```
