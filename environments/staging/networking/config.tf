terraform {
  backend "s3" {
    bucket = "staging-s3-acsgroup10"
    key    = "staging-network/terraform.tfstate"
    region = "us-east-1"
  }
}