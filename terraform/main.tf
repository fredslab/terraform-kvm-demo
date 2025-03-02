
# Base volume from the source image
resource "libvirt_volume" "vm1_base" {
  name   = "vm1-base"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

# Resized volume
resource "libvirt_volume" "vm1" {
  name           = "vm1"
  pool           = "default"
  format         = "qcow2"
  base_volume_id = libvirt_volume.vm1_base.id
  size           = var.vm_disk_size != null ? var.vm_disk_size : 2361393152
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.tpl")
  vars = {
    rootpassword = var.rootpassword
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "vm1" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name = var.vm_network
  }

  disk {
    volume_id = libvirt_volume.vm1.id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}

output "VM_Name" {
  value = libvirt_domain.vm1.name
}

output "VM_Memory" {
  value = libvirt_domain.vm1.memory
}

output "rendered_user_data" {
  value = data.template_file.user_data.rendered
}
