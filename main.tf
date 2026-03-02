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

# 1. Network: examplenetwork
resource "openstack_networking_network_v2" "examplenetwork" {
  name           = var.network_name
  admin_state_up = true
}

# 2. Subnet: examplesubnet mit 192.168.42.0/24
resource "openstack_networking_subnet_v2" "examplesubnet" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.examplenetwork.id
  cidr            = var.subnet_cidr
  ip_version      = 4
}

# 3. Router: examplerouter mit External Gateway
resource "openstack_networking_router_v2" "examplerouter" {
  name                = var.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

# 4. Router Interface: Add Subnet to Router
resource "openstack_networking_router_interface_v2" "router_if" {
  router_id = openstack_networking_router_v2.examplerouter.id
  subnet_id = openstack_networking_subnet_v2.examplesubnet.id
}

# 5. Security Group: examplesecurity
resource "openstack_networking_secgroup_v2" "examplesecurity" {
  name        = var.secgroup_name
  description = "SSH access only"
}

# 6. SG Rule: SSH (TCP 22 ingress from anywhere)
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.examplesecurity.id
}

# 7. Keypair: examplekey (upload public key)
resource "openstack_compute_keypair_v2" "examplekey" {
  name       = var.keypair_name
  public_key = file(var.ssh_public_key_path)
}

# 8. VM: examplevm (Boot-from-Volume 50GB rbd_fast)
resource "openstack_blockstorage_volume_v3" "root_volume" {
  name             = "${var.instance_name}-root"
  description      = "Root volume for examplevm"
  size             = var.boot_volume_size
  volume_type      = var.volume_type
  image_id         = data.openstack_images_image_v2.image.id
}

resource "openstack_compute_instance_v2" "examplevm" {
  name                  = var.instance_name
  image_name            = ""  # Nicht benötigt bei boot-from-volume
  flavor_name           = var.flavor_name
  key_pair              = openstack_compute_keypair_v2.examplekey.name
  security_groups       = [openstack_networking_secgroup_v2.examplesecurity.name]

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
    name = openstack_networking_network_v2.examplenetwork.name
  }

  depends_on = [
    openstack_networking_router_interface_v2.router_if,
    openstack_blockstorage_volume_v3.root_volume
  ]
}

# 9. Floating IP
resource "openstack_networking_floatingip_v2" "fip" {
  pool       = var.external_network_name
  depends_on = [openstack_compute_instance_v2.examplevm]
}

# 10. Associate Floating IP to VM
resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.examplevm.id
}
