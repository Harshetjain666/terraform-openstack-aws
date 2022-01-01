### INSTANCE DETAILS ###


# Get the image details
data "openstack_images_image_v2" "fedora_latest" {
  name       = var.image_name
}

# Create instance
resource "openstack_compute_instance_v2" "myinstance" {
  name            = var.instance_name
  image_id        = data.openstack_images_image_v2.fedora_latest.id
  flavor_name     = var.instance_flavor
  key_pair        = var.key_name
  security_groups = ["${openstack_compute_secgroup_v2.secgroup.name}"]
  user_data       = file("scripts/boot.sh")

  network {
    name = openstack_networking_network_v2.private.name
  }

  depends_on = [
   openstack_compute_secgroup_v2.secgroup,
   openstack_networking_network_v2.private
  ]
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "myip" {
  pool = var.external_network
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = "${openstack_networking_floatingip_v2.myip.address}"
  instance_id = "${openstack_compute_instance_v2.myinstance.id}"

  depends_on = [
    openstack_compute_instance_v2.myinstance
  ]
}

# Create a block storage  
resource "openstack_blockstorage_volume_v2" "myvol" {
  name = var.external_volume
  size = var.external_volume_size
}

# Attach block storage to instance
resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = "${openstack_compute_instance_v2.myinstance.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.myvol.id}"

  depends_on = [
    openstack_compute_instance_v2.myinstance
  ]
}


