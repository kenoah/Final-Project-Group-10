terraform {
  backend "s3" {
    bucket = "dev-s3-acsgroup10"
    key    = "dev-network/terraform.tfstate"
    region = "us-east-1"
  }
}