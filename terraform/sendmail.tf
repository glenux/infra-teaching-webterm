# module "welcome" {
#   source     = "git::https://github.com/cloudposse/terraform-null-smtp-mail.git?ref=master"
#   host       = var.smtp_host
#   port       = var.smtp_port
#   username   = var.smtp_username
#   password   = var.smtp_password
#   from       = var.email_from
#   to         = var.email_to
#   subject    = "Welcome ${first_name}"
#   body       = "Your account has been created. Login here: $${homepage}"
# 
#   vars = {
#     first_name = "Example"
#     homepage   = "https://cloudposse.com"
#   }
# }
# 
