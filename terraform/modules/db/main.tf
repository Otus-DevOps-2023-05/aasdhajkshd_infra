resource "yandex_compute_instance" "reddit-db" {

  count = var.instance_count

  allow_stopping_for_update = true

  name        = "reddit-db-${count.index}"
  platform_id = "standard-v1"

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.db_image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    # subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  # depends_on = [
  #   yandex_vpc_network.app-network
  # ]
}
