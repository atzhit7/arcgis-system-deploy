resource "aws_kms_key" "this" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}