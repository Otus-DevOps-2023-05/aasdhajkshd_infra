resource "yandex_lb_network_load_balancer" "reddit-app" {
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
  name  = "reddit-app"

  target {
    subnet_id = var.subnet_id
    address   = yandex_compute_instance.reddit-app[0].network_interface[0].ip_address
  }

  target {
    subnet_id = var.subnet_id
    address   = yandex_compute_instance.reddit-app[1].network_interface[0].ip_address
  }
}

output "lb_ip_address" {
  value = yandex_lb_network_load_balancer.reddit-app.listener.*.external_address_spec[0].*.address
}
