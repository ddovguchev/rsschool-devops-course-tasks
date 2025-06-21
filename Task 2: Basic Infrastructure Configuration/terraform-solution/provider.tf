provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "rs-school-tasks-dd"
    key     = "task2/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}