terraform {
  backend "s3" {
    bucket = "staging-s3-acsgroup10"
    key    = "staging-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}