resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.yml.tmpl",
    {
      dns_gateways         = gandi_livedns_record.mongo_gateways.*
      dns_servers          = gandi_livedns_record.mongo_gateways.*
      mongo_gateways       = openstack_compute_instance_v2.mongo_gateways.*
      mongo_servers        = openstack_compute_instance_v2.mongo_servers.*
      mongo_groups_count   = var.mongo_groups_count
      mongo_replicas_count = var.mongo_replicas_count
    }
  )
  filename        = "_build/ansible_inventory"
  file_permission = "0644"

}

