data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

resource "openstack_networking_network_v2" "examplenetwork" {
  name           = var.network_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "examplesubnet" {
  name       = var.subnet_name
  network_id = openstack_networking_network_v2.examplenetwork.id
  cidr       = var.subnet_cidr
  ip_version = 4
}

resource "openstack_networking_router_v2" "examplerouter" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_router_interface_v2" "router_if" {
  router_id = openstack_networking_router_v2.examplerouter.id
  subnet_id = openstack_networking_subnet_v2.examplesubnet.id
}

resource "openstack_networking_secgroup_v2" "examplesecurity" {
  name        = var.secgroup_name
  description = "examplesecurity"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.examplesecurity.id
}

resource "openstack_compute_keypair_v2" "examplekey" {
  name       = var.keypair_name
  public_key = file(var.ssh_public_key_path)
}

resource "openstack_compute_instance_v2" "examplevm" {
  name            = var.instance_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.examplekey.name
  security_groups = [openstack_networking_secgroup_v2.examplesecurity.name]

  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    volume_size           = var.boot_volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
    volume_type           = var.volume_type
  }

  network {
    port = openstack_networking_port_v2.vm_port.id
  }

}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.external_network_name
}

resource "openstack_networking_port_v2" "vm_port" {
  name               = "${var.instance_name}-port"
  network_id         = openstack_networking_network_v2.examplenetwork.id
  security_group_ids = [openstack_networking_secgroup_v2.examplesecurity.id]

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.examplesubnet.id
  }
}

resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  port_id     = openstack_networking_port_v2.vm_port.id
  depends_on = [
    openstack_networking_router_v2.examplerouter,
    openstack_networking_router_interface_v2.router_if
  ]
}
