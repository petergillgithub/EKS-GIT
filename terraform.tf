terraform {
  required_version = "~>1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }

   backend "s3" {

    bucket = "terraform-remotestatefile-s3"
    key    = "eks-demo/dev/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-locking"
  }
}