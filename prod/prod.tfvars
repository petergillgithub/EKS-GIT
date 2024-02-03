vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = ["10.0.0.0/21","10.0.8.0/21","10.0.16.0/20"]
private_subnet_cidr = [ "10.0.32.0/19","10.0.64.0/18","10.0.128.0/17" ]
comman_tags = {
    "Env" = "Production"
    "Team" = "Terraform"
}
