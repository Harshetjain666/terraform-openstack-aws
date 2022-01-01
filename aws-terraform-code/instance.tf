terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  profile = "new"
}



resource "aws_instance" "web" {
  ami           = "ami-0f2e255ec956ade7f"
  instance_type = "t2.xlarge" 
  key_name = "new-account"
  root_block_device {

    volume_size = 100
  
  }

  tags = {
    Name = "OpenStack Instance"
  }
}

