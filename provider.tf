provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "data-platform-ecs-terraform-state"
    key    = "prod/data-platform-ecs.tfstate"
    region = "ap-south-1"
  }
}

