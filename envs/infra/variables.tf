variable "name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "domain" {
  type = string
}

variable "blue_subdomain" {
  type = string
}

variable "green_subdomain" {
  type = string
}

variable "arcgisserver_prefix" {
  type = string
}
variable "arcgisportal_prefix" {
  type = string
}
variable "arcgisdatastore_prefix" {
  type = string
}
variable "region" {
  type = string
}

data "aws_availability_zones" "az" {
  state         = "available"
  exclude_names = ["ap-southeast-2a"]
}

data "aws_elb_service_account" "alb_log" {}
