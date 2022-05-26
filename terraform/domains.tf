
resource "gandi_livedns_record" "gateways_exploreko_org" {
  count  = var.mongo_groups_count
  zone   = var.domain_name
  name   = "gateway${count.index}.teaching"
  type   = "A"
  ttl    = 3600
  values = [openstack_compute_instance_v2.mongo_gateway[count.index].access_ip_v4]
}

resource "gandi_livedns_record" "mongos_exploreko_org" {
  count = var.mongo_replicas_count * var.mongo_groups_count
  zone   = var.domain_name
  name   = "mongo${count.index}.teaching"
  type   = "A"
  ttl    = 3600
  values = [openstack_compute_instance_v2.mongo_servers[count.index].access_ip_v4]
}
