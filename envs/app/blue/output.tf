output "aws_instance_arcgisserver_id" {
  value = aws_instance.arcgisserver.id
}
output "aws_instance_arcgisportal_id" {
  value = aws_instance.arcgisportal.id
}
output "aws_instance_arcgisdatastore_id" {
  value = aws_instance.arcgisdatastore.id
}

data "aws_region" "current" {}

data "aws_kms_secrets" "parameters" {
  secret {
    name    = "servercert_password"
    payload = var.payload_servercert
  }
  secret {
    name    = "portaladmin_password"
    payload = var.payload_portaladmin
  }
  secret {
    name    = "serveradmin_password"
    payload = var.payload_serveradmin
  }
  secret {
    name    = "serviceaccount_password"
    payload = var.payload_serviceaccount
  }
}

resource "aws_ssm_parameter" "serveradmin_password" {
  name  = "/${var.name}/${terraform.workspace}/siteadmin-password"
  type  = "SecureString"
  value = data.aws_kms_secrets.parameters.plaintext["serveradmin_password"]

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "portaladmin_password" {
  name  = "/${var.name}/${terraform.workspace}/portaladmin_password"
  type  = "SecureString"
  value = data.aws_kms_secrets.parameters.plaintext["portaladmin_password"]

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "servercert_password" {
  name  = "/${var.name}/${terraform.workspace}/servercert_password"
  type  = "SecureString"
  value = data.aws_kms_secrets.parameters.plaintext["servercert_password"]

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "serviceaccount_password" {
  name  = "/${var.name}/${terraform.workspace}/serviceaccount_password"
  type  = "SecureString"
  value = data.aws_kms_secrets.parameters.plaintext["serviceaccount_password"]

  lifecycle {
    ignore_changes = [value]
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("../ansible/data/inventory.tmpl",
    {
      arcgisdatastorenode_private_dns = aws_instance.arcgisdatastore.private_dns
      arcgisservernode_private_dns    = aws_instance.arcgisserver.private_dns
      arcgisportalnode_private_dns    = aws_instance.arcgisportal.private_dns
      arcgisdatastorenode_password    = "${rsadecrypt(aws_instance.arcgisdatastore.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))}"
      arcgisservernode_password       = "${rsadecrypt(aws_instance.arcgisserver.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))}"
      arccgisportalnode_password      = "${rsadecrypt(aws_instance.arcgisportal.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))}"
      deploy_purpose                  = var.deploy_purpose
    }
  )
  filename = "../ansible/inventory"
}

resource "local_file" "ansible_variables" {
  content = templatefile("../ansible/data/vars_global.tmpl",
    {
      arcgisdatastore_internal_dns    = aws_route53_record.arcgisdatastore.name
      arcgisserver_internal_dns       = aws_route53_record.arcgisserver.name
      arcgisportal_internal_dns       = aws_route53_record.arcgisportal.name
      arcgisportal_public_dns         = "${terraform.workspace}-p.${data.terraform_remote_state.infra.outputs.root_domain_name}"
      arcgisserver_public_dns         = "${terraform.workspace}-s.${data.terraform_remote_state.infra.outputs.root_domain_name}"
      domain                          = data.terraform_remote_state.infra.outputs.root_domain_name
      server_adminuser_password       = data.aws_kms_secrets.parameters.plaintext["serveradmin_password"]
      portal_adminuser_password       = data.aws_kms_secrets.parameters.plaintext["portaladmin_password"]
      servercert_password             = data.aws_kms_secrets.parameters.plaintext["servercert_password"]
      arcgis_service_account_password = data.aws_kms_secrets.parameters.plaintext["serviceaccount_password"]
    }
  )
  filename = "../ansible/vars_global.yaml"
}

resource "local_file" "webgisdr_properties" {
  content = templatefile("../ansible/data/webgisdr.properties.tmpl",
    {
      arcgisportal_internal_dns = aws_route53_record.arcgisportal.name
      portal_adminuser_password = data.aws_kms_secrets.parameters.plaintext["portaladmin_password"]
      backup_bucket_name        = aws_s3_bucket.system_backup.bucket
      backup_bucket_region      = data.aws_region.current.name
    }
  )
  filename = "../ansible/webgisdr.properties"
}

# resource "local_file" "createportal_properties" {
#   content = templatefile("../ansible/data/createportal.properties.tmpl",
#     {
#       portal_adminuser_password = data.aws_kms_secrets.parameters.plaintext["portaladmin_password"]
#     }
#   )
#   filename = "../ansible/data/createportal.properties"
# }

# resource "local_file" "dev_createportal_properties" {
#   content = templatefile("../ansible/data/dev_createportal.properties.tmpl",
#     {
#       portal_adminuser_password = data.aws_kms_secrets.parameters.plaintext["portaladmin_password"]
#     }
#   )
#   filename = "../ansible/data/dev_createportal.properties"
# }

data "aws_s3_bucket" "system_config" {
  bucket = data.terraform_remote_state.infra.outputs.aws_s3_bucket_systemconfig
}

resource "aws_s3_bucket_object" "ansible_inventory" {
  depends_on = [local_file.ansible_variables]
  bucket     = data.aws_s3_bucket.system_config.id
  key        = "env:/${terraform.workspace}/${data.terraform_remote_state.infra.outputs.blue_domain_name}/inventory"
  source     = "../ansible/inventory"
  # etag = filemd5("../ansible/inventory")
}

resource "aws_s3_bucket_object" "ansible_variables" {
  depends_on = [local_file.ansible_variables]
  bucket     = data.aws_s3_bucket.system_config.id
  key        = "env:/${terraform.workspace}/${data.terraform_remote_state.infra.outputs.blue_domain_name}/vars_global.yaml"
  source     = "../ansible/vars_global.yaml"
  # etag = filemd5("../ansible/vars_global.yaml")
}

# resource "aws_s3_bucket_object" "createportal_properties" {
#   depends_on = [local_file.createportal_properties]
#   bucket = data.aws_s3_bucket.system_config.id
#   key    = "env:/${terraform.workspace}/${data.terraform_remote_state.infra.outputs.blue_domain_name}/createportal.properties"
#   source = "../ansible/data/createportal.properties"
#   # etag = filemd5("../ansible/data/createportal.properties")
# }

# resource "aws_s3_bucket_object" "dev_createportal_properties" {
#   depends_on = [local_file.dev_createportal_properties]
#   bucket = data.aws_s3_bucket.system_config.id
#   key    = "env:/${terraform.workspace}/${data.terraform_remote_state.infra.outputs.blue_domain_name}/dev_createportal.properties"
#   source = "../ansible/data/dev_createportal.properties"
#   # etag = filemd5("../ansible/data/dev_createportal.properties")
# }

resource "aws_ssm_parameter" "arcgisdatastore" {
  depends_on = [aws_instance.arcgisdatastore]
  name       = "/${var.name}/${terraform.workspace}-${data.terraform_remote_state.infra.outputs.blue_domain_name}-datastore/ec2-win-password"
  type       = "SecureString"
  value      = rsadecrypt(aws_instance.arcgisdatastore.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))
  overwrite  = true
}
resource "aws_ssm_parameter" "arcgisserver" {
  depends_on = [aws_instance.arcgisserver]
  name       = "/${var.name}/${terraform.workspace}-${data.terraform_remote_state.infra.outputs.blue_domain_name}-server/ec2-win-password"
  type       = "SecureString"
  value      = rsadecrypt(aws_instance.arcgisserver.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))
  overwrite  = true
}
resource "aws_ssm_parameter" "arcgisportal" {
  depends_on = [aws_instance.arcgisportal]
  name       = "/${var.name}/${terraform.workspace}-${data.terraform_remote_state.infra.outputs.blue_domain_name}-portal/ec2-win-password"
  type       = "SecureString"
  value      = rsadecrypt(aws_instance.arcgisportal.password_data, nonsensitive(tls_private_key.keygen.private_key_pem))
  overwrite  = true
}