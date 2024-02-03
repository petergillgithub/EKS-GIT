variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  
}


variable "public_subnet_cidr" {
  type = list(string)
  default = [ "10.0.0.0/21","10.0.8.0/21","10.0.16.0/20" ]
  
}

variable "private_subnet_cidr" {
  type = list(string)
  default = [ "10.0.32.0/19","10.0.64.0/18","10.0.128.0/17" ]
  
}

variable "comman_tags" {
  type = map(string)
  default = {
    "Env" = "DEV"
    "Team" = "Terraform"
  }
  
}

variable "worker_role_policy" {
    type = set(string)
    default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}