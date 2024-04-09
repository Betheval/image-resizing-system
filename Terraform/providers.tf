terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.44.0"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  region = "eu-west-1"
}

