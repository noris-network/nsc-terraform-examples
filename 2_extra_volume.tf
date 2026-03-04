resource "openstack_blockstorage_volume_v3" "examplevolume" {
  name              = "examplevolume"
  size              = var.extra_volume_size
  volume_type       = "rbd_fast"
  availability_zone = openstack_compute_instance_v2.examplevm.availability_zone
}

resource "openstack_compute_volume_attach_v2" "volume_attach" {
  instance_id = openstack_compute_instance_v2.examplevm.id
  volume_id   = openstack_blockstorage_volume_v3.examplevolume.id
  depends_on  = [openstack_compute_instance_v2.examplevm]
}
