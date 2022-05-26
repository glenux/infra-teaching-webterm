
# provisioner "local-exec" {
#   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i outputs/inventory --private-key ${var.private_key} -e 'pub_key=${var.pub_key}' playbook.yml"
# }
