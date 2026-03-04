resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.examplesecurity.id
}

resource "openstack_lb_loadbalancer_v2" "examplelb" {
  name                  = "exampleloadbalancer"
  vip_subnet_id         = openstack_networking_subnet_v2.examplesubnet.id
  loadbalancer_provider = "ovn"
}

resource "openstack_lb_listener_v2" "listener" {
  name            = "examplevm-listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.examplelb.id
  default_pool_id = openstack_lb_pool_v2.pool.id
}

resource "openstack_lb_pool_v2" "pool" {
  name            = "examplevm-pool"
  protocol        = "TCP"
  lb_method       = "SOURCE_IP_PORT"
  loadbalancer_id = openstack_lb_loadbalancer_v2.examplelb.id
}

resource "openstack_lb_member_v2" "member" {
  name          = "examplevm-member"
  protocol_port = 80
  subnet_id     = openstack_networking_subnet_v2.examplesubnet.id
  address       = openstack_compute_instance_v2.examplevm.network.0.fixed_ip_v4
  pool_id       = openstack_lb_pool_v2.pool.id
}

resource "openstack_lb_monitor_v2" "monitor" {
  name        = "http-monitor"
  type        = "TCP"
  delay       = 5
  max_retries = 3
  timeout     = 10
  pool_id     = openstack_lb_pool_v2.pool.id
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool = var.external_network_name
}

resource "openstack_networking_floatingip_associate_v2" "lb_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.lb_fip.address
  port_id     = openstack_lb_loadbalancer_v2.examplelb.vip_port_id
}
