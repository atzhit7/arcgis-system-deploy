resource "aws_route53_record" "arcgisserver" {
  zone_id = data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_id
  name    = "${terraform.workspace}-${data.terraform_remote_state.infra.outputs.arcgisserver_prefix}.${data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.arcgisserver.private_ip}"]
}

resource "aws_route53_record" "arcgisportal" {
  zone_id = data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_id
  name    = "${terraform.workspace}-${data.terraform_remote_state.infra.outputs.arcgisportal_prefix}.${data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.arcgisportal.private_ip}"]
}

resource "aws_route53_record" "arcgisdatastore" {
  zone_id = data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_id
  name    = "${terraform.workspace}-${data.terraform_remote_state.infra.outputs.arcgisdatastore_prefix}.${data.terraform_remote_state.infra.outputs.aws_route53_zone_private_green_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.arcgisdatastore.private_ip}"]
}