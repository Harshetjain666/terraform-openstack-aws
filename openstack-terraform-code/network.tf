### NETWORK CONFIGURATION ###


# Get id of external network
data "openstack_networking_network_v2" "network" {
  name = var.external_network
}

# Router creation
resource "openstack_networking_router_v2" "generic" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.network.id
}

# Network creation
resource "openstack_networking_network_v2" "private" {
  name = "private-network"
}

### HTTP SUBNET ####

# Subnet http configuration
resource "openstack_networking_subnet_v2" "http" {
  name            = var.network_http["subnet_name"]
  network_id      = openstack_networking_network_v2.private.id
  cidr            = var.network_http["cidr"]
  dns_nameservers = var.dns_server

  depends_on = [
    openstack_networking_network_v2.private
  ]
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "http" {
  router_id = openstack_networking_router_v2.generic.id
  subnet_id = openstack_networking_subnet_v2.http.id

  depends_on = [
    openstack_networking_subnet_v2.http
  ]
}