output "aws_vpc_id" {
  value = aws_vpc.this.id
}

output "aws_subnet_public_maplist" {
  value = aws_subnet.public
}

output "aws_subnet_private_web_maplist" {
  value = aws_subnet.private_web
}

output "aws_security_group_private_web_id" {
  value = aws_security_group.private_web.id
}

output "aws_subnet_private_data_maplist" {
  value = aws_subnet.private_data
}

output "aws_security_group_private_data_id" {
  value = aws_security_group.private_data.id
}

output "alb_public_arn" {
  value = aws_alb.public.arn
}

output "alb_public_dns" {
  value = aws_alb.public.dns_name
}

output "aws_acm_certificate_root_arn" {
  value     = aws_acm_certificate.root.arn
  sensitive = true
}

output "aws_ami_instance_profile_ec2_name" {
  value = aws_iam_instance_profile.ec2.name
}

output "root_domain_name" {
  value = var.domain
}

output "blue_domain_name" {
  value = var.blue_subdomain
}

output "green_domain_name" {
  value = var.green_subdomain
}

output "aws_route53_zone_root_id" {
  value = data.aws_route53_zone.root.id
}

output "aws_route53_zone_private_blue_id" {
  value = aws_route53_zone.private_blue.id
}

output "aws_route53_zone_private_blue_name" {
  value = aws_route53_zone.private_blue.name
}

output "aws_route53_zone_private_green_id" {
  value = aws_route53_zone.private_green.id
}

output "aws_route53_zone_private_green_name" {
  value = aws_route53_zone.private_green.name
}

output "arcgisserver_prefix" {
  value = var.arcgisserver_prefix
}
output "arcgisportal_prefix" {
  value = var.arcgisportal_prefix
}
output "arcgisdatastore_prefix" {
  value = var.arcgisdatastore_prefix
}

output "aws_s3_bucket_systemconfig" {
  value = aws_s3_bucket.system_config.bucket
}

resource "local_file" "aws_security_group_private_web_id" {
  filename = "./group_id"
  content  = aws_security_group.private_web.id
}

resource "local_file" "aws_security_group_private_data_id" {
  filename = "./group_id"
  content  = aws_security_group.private_data.id
}

resource "aws_ssm_parameter" "aws_security_group_private_web_id" {
  depends_on = [aws_security_group.private_web]
  name       = "/${var.name}/manage/private-web-sg-id"
  type       = "String"
  value      = aws_security_group.private_web.id
}

resource "aws_ssm_parameter" "aws_security_group_private_data_id" {
  depends_on = [aws_security_group.private_data]
  name       = "/${var.name}/manage/private-data-sg-id"
  type       = "String"
  value      = aws_security_group.private_data.id
}