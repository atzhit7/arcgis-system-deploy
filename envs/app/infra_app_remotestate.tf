data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "REMOTE STATE BUCKET NAME"
    key    = "dev/infra_v1.0.0.tfstate"
    region = "BUCKET REGION"
  }
}

data "terraform_remote_state" "app_blue" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket = "REMOTE STATE BUCKET NAME"
    key    = "dev/app_blue_v1.0.0.tfstate"
    region = "BUCKET REGION"
  }
}

data "terraform_remote_state" "app_green" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket = "REMOTE STATE BUCKET NAME"
    key    = "dev/app_green_v1.0.0.tfstate"
    region = "BUCKET REGION"
  }
}
# if using workspace, the bucket path is automatically changed to env:/workspace/dev...