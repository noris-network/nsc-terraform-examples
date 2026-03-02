variable "external_network_name" {
  description = "Name des externen (Public) Networks für Floating IPs"
  type        = string
  default     = "public"
}

variable "image_name" {
  description = "Glance Image Name"
  type        = string
  default     = "Ubuntu 22.04"
}

variable "flavor_name" {
  description = "Nova Flavor Name"
  type        = string
  default     = "m1.small"
}

variable "ssh_public_key_path" {
  description = "Pfad zu deinem SSH Public Key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "instance_name" {
  description = "Name der VM"
  type        = string
  default     = "tf-demo-1"
}

variable "cidr" {
  description = "CIDR des privaten Subnetzes"
  type        = string
  default     = "10.10.10.0/24"
}

variable "external_network_name" {
  default = "external"  # Anleitung verwendet "external"
}

variable "image_name" {
  default = "Debian 12"
}

variable "flavor_name" {
  default = "SCS-1V-2"  # Diskless Flavor wie in Anleitung
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.cloud.pub"  # Passe an, generiere ggf. mit ssh-keygen
}

variable "instance_name" {
  default = "examplevm"
}

variable "subnet_cidr" {
  default = "192.168.42.0/24"  # Genau wie Anleitung
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
  default = 50  # 50 GB Root Volume
}

variable "volume_type" {
  default = "rbd_fast"  # Wie in Anleitung
}
