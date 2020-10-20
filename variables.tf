variable "region" {
  default = "us-east-1"
}

variable "vpc_name" {
  description = "VPC name"
  default = "kubeflow-terraform-vpc"
}

variable "vpc_cidr" {
  description = "VPC IP scope"
  default = "172.16.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets IP scope"
  type        = list(string)

  default = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets IP scope"
  type        = list(string)

  default = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

variable "cluster_name" {
  description = "EKS Cluster name"
  default = "kubeflow-eks-terraform"
}

variable "cluster_env" {
  description = "Cluster env label name"
  default = "test"
}

variable "node_desired_capacity" {
  description = "EKS node desired capacity"
  default = "4"
}

variable "node_max_capacity" {
  description = "EKS node max capacity"
  default = "10"
}

variable "node_min_capacity" {
  description = "EKS node min capacity"
  default = "2"
}

variable "node_ec2_type" {
  description = "EKS node ec2 instance type"
  default = "m5.large"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
