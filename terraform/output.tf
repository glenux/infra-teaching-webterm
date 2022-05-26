resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.tmpl",
    {
		  mongo_gateways = openstack_compute_instance_v2.mongo_gateway.*
		  mongo_servers = openstack_compute_instance_v2.mongo_servers.*
		  mongo_groups_count = var.mongo_groups_count
		  mongo_replicas_count = var.mongo_replicas_count
    }
  )
  filename = "outputs/inventory"
  file_permission = "0644"
}
