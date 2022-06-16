
resource "null_resource" "ansible" {
  count = (var.mongo_gateways_enable && var.mongo_servers_enable) ? 1 : 0
  depends_on = [local_file.ansible_inventory]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    working_dir = "../ansible"
    command     = <<-EOT
      ansible-playbook \
        -i inventories/terraform \
        --private-key ${var.ssh_private_key} \
        -e 'pub_key=${var.ssh_public_key}' \
        playbook.yml
    EOT
  }

}

