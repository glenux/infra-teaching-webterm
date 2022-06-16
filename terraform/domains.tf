
resource "gandi_livedns_record" "mongo_gateways" {
  count  = var.mongo_groups_count
  zone   = var.domain_name
  name   = "gateway${count.index}.${var.subdomain_suffix}"
  type   = "A"
  ttl    = 3600
  values = [openstack_compute_instance_v2.mongo_gateways[count.index].access_ip_v4]
}

resource "gandi_livedns_record" "mongo_servers" {
  count  = var.mongo_replicas_count * var.mongo_groups_count
  zone   = var.domain_name
  name   = "mongo${openstack_compute_instance_v2.mongo_servers[count.index].metadata.mongo_group_id}-${openstack_compute_instance_v2.mongo_servers[count.index].metadata.mongo_group_index}.${var.subdomain_suffix}"
  type   = "A"
  ttl    = 3600
  values = [openstack_compute_instance_v2.mongo_servers[count.index].access_ip_v4]
}
