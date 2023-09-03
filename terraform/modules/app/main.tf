resource "yandex_compute_instance" "reddit-app" {

  count = var.instance_count

  allow_stopping_for_update = true

  name        = "reddit-app-${count.index}"
  platform_id = "standard-v1"

  labels = {
    tags = "reddit-app"
  }

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
      image_id = var.app_image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    # subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
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
