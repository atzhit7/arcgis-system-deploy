## public hosted zone
data "aws_route53_zone" "root" {
  name = var.domain
}

resource "aws_acm_certificate" "root" {
  domain_name               = data.aws_route53_zone.root.name
  subject_alternative_names = [format("*.%s", data.aws_route53_zone.root.name)]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.root.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root.id
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn         = aws_acm_certificate.root.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}

resource "aws_route53_zone" "private_blue" {
  name = "${var.blue_subdomain}.${var.domain}"
  vpc {
    vpc_id = aws_vpc.this.id
  }
}

resource "aws_route53_zone" "private_green" {
  name = "${var.green_subdomain}.${var.domain}"
  vpc {
    vpc_id = aws_vpc.this.id
  }
}