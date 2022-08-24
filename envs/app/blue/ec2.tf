resource "aws_instance" "arcgisserver" {
  ami                         = data.aws_ami.arcgisserver.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.aws_security_group_private_web_id]
  subnet_id                   = data.terraform_remote_state.infra.outputs.aws_subnet_private_web_maplist[0].id
  key_name                    = aws_key_pair.key_pair.id
  associate_public_ip_address = false
  get_password_data           = true
  iam_instance_profile        = data.terraform_remote_state.infra.outputs.aws_ami_instance_profile_ec2_name
  tags = {
    SystemColor = var.color
    Name        = "${var.name}-server"
    SystemRole  = "arcgisserver"
  }
}
resource "aws_instance" "arcgisportal" {
  ami                         = data.aws_ami.arcgisportal.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.aws_security_group_private_web_id]
  subnet_id                   = data.terraform_remote_state.infra.outputs.aws_subnet_private_web_maplist[0].id
  key_name                    = aws_key_pair.key_pair.id
  associate_public_ip_address = false
  get_password_data           = true
  iam_instance_profile        = data.terraform_remote_state.infra.outputs.aws_ami_instance_profile_ec2_name
  tags = {
    SystemColor = var.color
    Name        = "${var.name}-portal"
    SystemRole  = "arcgisportal"
  }
}

resource "aws_instance" "arcgisdatastore" {
  ami                         = data.aws_ami.arcgisdatastore.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.aws_security_group_private_data_id]
  subnet_id                   = data.terraform_remote_state.infra.outputs.aws_subnet_private_data_maplist[0].id
  key_name                    = aws_key_pair.key_pair.id
  associate_public_ip_address = false
  get_password_data           = true
  iam_instance_profile        = data.terraform_remote_state.infra.outputs.aws_ami_instance_profile_ec2_name
  tags = {
    SystemColor = var.color
    Name        = "${var.name}-datastore"
    SystemRole  = "arcgisdatastore"
  }
}