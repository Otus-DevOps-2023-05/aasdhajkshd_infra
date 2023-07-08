output "external_ip_address" {
  value = [for instance in yandex_compute_instance.reddit-app : instance.network_interface.0.nat_ip_address]
}

# output "lb_ip_address" {
#   value = yandex_lb_network_load_balancer.reddit-app.listener.*.external_address_spec[0].*.address
# }
