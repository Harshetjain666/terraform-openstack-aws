### PARAMETER FILE ###


# External network
variable "external_network" {
  type    = string
  default = "public"
}

# Http subnet details
variable "network_http" {
  type    = map(string)
  default = {
    subnet_name = "http_subnet"
    cidr        = "192.168.1.0/24"
  }
}

variable "dns_server" {
  type    = list(string)
  default = [ "8.8.8.8", "8.8.4.4" ]
}

# Glance
variable "image_name" {
  type    = string  
  default = "fedora"  
}

# Instance details
variable "instance_name" {
  type    = string
  default = "web" 
}
 
variable "instance_flavor" {
  type    = string
  default = "m1.medium"  
}

variable "key_name" {
  type    = string
  default = "openstack"
}

variable "external_volume" {
  type    = string
  default = "http-storage"  
}

variable "external_volume_size" {
  type    = string
  default = "5"
}