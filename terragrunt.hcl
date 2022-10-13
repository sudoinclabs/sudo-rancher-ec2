generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
     region  = "us-east-1"
     profile = "default"
  }
  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.57"
    }
}
  required_version = "~> 1.2.4"
  backend "s3" {}
  }
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt                 = true
    bucket                  = "vairome-terraform-state-k8s-app"
    key                     = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table          = "your-terraform-lock-table"
    profile                 = "default"
    region                  = "us-east-1"
  }
}
