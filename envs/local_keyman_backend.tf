terraform {
  backend "s3" {
    bucket  = "REMOTE STATE BUCKET NAME"
    key     = "dev/keyman_v1.0.0.tfstate"
    region  = "BUCKET REGION"
    profile = "YOUR PROFILE"
  }
}