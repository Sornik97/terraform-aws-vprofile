terraform {
  backend "s3" {
    bucket = "terra-vprofile-state97"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}