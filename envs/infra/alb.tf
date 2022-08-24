resource "aws_alb" "public" {
  name                       = var.name
  security_groups            = [aws_security_group.alb.id]
  subnets                    = aws_subnet.public.*.id
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.alb_log.bucket
  }
}