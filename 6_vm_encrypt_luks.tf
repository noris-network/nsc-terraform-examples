resource "openstack_compute_instance_v2" "luks_vm" {
  name        = "example-luks"
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.examplekey.name

  network {
    name = openstack_networking_network_v2.examplenetwork.name
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = var.luks_volume_size
    delete_on_termination = true
    volume_type           = "LUKS"
  }

  security_groups = [openstack_networking_secgroup_v2.examplesecurity.name]
}
