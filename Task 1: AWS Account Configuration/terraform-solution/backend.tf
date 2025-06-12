terraform {
  backend "s3" {
    bucket  = "rs-school-tasks-dd"
    key     = "task1/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}