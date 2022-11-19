terraform {
  required_providers {
    aws = {
        source = "devops/aws"
        version = "3.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
    access_key = ""
    secret_key = ""
}
