output "instance_id" {
  value = openstack_compute_instance_v2.examplevm.id # ← "examplevm" statt "vm"
}

output "floating_ip" {
  value = openstack_networking_floatingip_v2.fip.address
}

output "loadbalancer_ip" {
  value = openstack_networking_floatingip_v2.lb_fip.address
}

output "private_ip" {
  value = openstack_compute_instance_v2.examplevm.network.0.fixed_ip_v4 # ← "examplevm"
}

output "ssh_command" {
  value = "ssh -i ${replace(var.ssh_public_key_path, ".pub", "")} debian@${openstack_networking_floatingip_v2.fip.address}"
}
