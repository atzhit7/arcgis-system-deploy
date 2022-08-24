variable "name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type        = string
  description = "tf-key-pair"
  default     = "tf-key"
}
variable "color" {
  type        = string
  description = "color of deployment"
}
variable "deploy_purpose" {
  type        = string
  description = "purpose of deployment, prod or dev. specified with command only"
  default     = ""
}
data "aws_ami" "arcgisserver" {
  most_recent = true
  name_regex  = "^${var.deploy_purpose}-arcgisserver"
  owners      = ["self"]
  filter {
    name   = "tag:AMI_ROLE"
    values = ["${var.deploy_purpose}"]
  }
}
data "aws_ami" "arcgisportal" {
  most_recent = true
  name_regex  = "^${var.deploy_purpose}-arcgisportal"
  owners      = ["self"]
  filter {
    name   = "tag:AMI_ROLE"
    values = ["${var.deploy_purpose}"]
  }
}
data "aws_ami" "arcgisdatastore" {
  most_recent = true
  name_regex  = "^${var.deploy_purpose}-arcgisdatastore"
  owners      = ["self"]
  filter {
    name   = "tag:AMI_ROLE"
    values = ["${var.deploy_purpose}"]
  }
}

# Esri