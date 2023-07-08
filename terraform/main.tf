terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.94.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  # token = var.token
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

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

/* resource "yandex_lb_network_load_balancer" "reddit-app" {
  name = "reddit-app"

  listener {
    name = "listener-reddit-app"
    port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.reddit-app.id

    healthcheck {
      name = "http"
      http_options {
        port = 9292
        path = "/"
      }
    }
  }
}

resource "yandex_lb_target_group" "reddit-app" {
  count = var.instance_count
  name = "reddit-app"

  target {
    subnet_id = var.subnet_id
    address = yandex_compute_instance.reddit-app[count.index].network_interface[0].ip_address
  }
}
 */