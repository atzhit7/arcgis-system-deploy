resource "aws_route53_record" "alb_cust" {
  allow_overwrite = true
  zone_id         = data.terraform_remote_state.infra.outputs.aws_route53_zone_root_id
  name            = "${terraform.workspace}-p"
  records = [
    data.terraform_remote_state.infra.outputs.alb_public_dns
  ]
  ttl  = 300
  type = "CNAME"
}

resource "aws_route53_record" "alb_cust_server" {
  allow_overwrite = true
  zone_id         = data.terraform_remote_state.infra.outputs.aws_route53_zone_root_id
  name            = "${terraform.workspace}-s"
  records = [
    data.terraform_remote_state.infra.outputs.alb_public_dns
  ]
  ttl  = 300
  type = "CNAME"
}