####VPC

vpc_name	     = "kubeflow-terraform-vpc"	
vpc_cidr             = "172.16.0.0/16"
private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]

####EKS

cluster_name         = "kubeflow-eks-terraform"
cluster_env	     = "test"
node_desired_capacity = "4"
node_max_capacity    = "10"
node_min_capacity    = "2"
node_ec2_type	     = "m5.large"


