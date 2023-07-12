resource "yandex_compute_instance" "reddit-app" {

  count = var.instance_count

  allow_stopping_for_update = true

  name        = "${var.vm_name_pfx}-${count.index}"
  platform_id = "standard-v1"

  metadata = {
    # user-data = file("meta.yaml")
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }
}