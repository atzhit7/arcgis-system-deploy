data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "REMOTE STATE BUCKET NAME"
    key    = "dev/infra_v1.0.0.tfstate"
    region = "BUCKET REGION"
  }
}