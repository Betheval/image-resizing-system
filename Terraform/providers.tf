

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.44.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }

  }
}

provider "aws" {
  # Configuration options
}
provider "random" {
  # Configuration options
}



