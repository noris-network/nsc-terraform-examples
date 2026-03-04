variable "external_network_name" {
  default = "external"
}

variable "image_name" {
  default = "Debian 12"
}

variable "flavor_name" {
  default = "SCS-1V-2"
}

variable "ssh_public_key_path" {
  type    = string
  default = "id_rsa.cloud.pub"
}

variable "instance_name" {
  default = "examplevm"
}

variable "subnet_cidr" {
  default = "192.168.42.0/24"
}

variable "network_name" {
  default = "examplenetwork"
}

variable "subnet_name" {
  default = "examplesubnet"
}

variable "router_name" {
  default = "examplerouter"
}

variable "secgroup_name" {
  default = "examplesecurity"
}

variable "keypair_name" {
  default = "examplekey"
}

variable "boot_volume_size" {
  default = 50
}

variable "volume_type" {
  default = "rbd_fast"
}

variable "enable_extra_volume" { default = false }
variable "extra_volume_size" { default = 10 }

variable "enable_swift" { default = false }
variable "enable_lb" { default = false }
variable "enable_ec2_creds" { default = false }
variable "enable_luks_vm" { default = false }
variable "enable_glance_upload" { default = false }

variable "luks_volume_size" { default = 10 }
variable "s3_bucket_name" { default = "example-bucket" }
variable "resize_flavor" { default = "SCS-2V-4" }
variable "enable_resize" { default = false }
