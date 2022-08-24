provider "aws" {
  region = "AWS REGION"

  default_tags {
    tags = {
      Env            = "develop"
      Project        = "arcgis-system-deploy-automatically"
      ServiceEdition = "basic"
      SystemRole     = "arcgis-system"
      CostManage     = "sample"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.3"
    }
  }

  required_version = "1.1.9"
}