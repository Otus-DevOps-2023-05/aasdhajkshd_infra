output "external_ip_address_db" {
  value = [for instance in yandex_compute_instance.reddit-db : instance.network_interface[0].nat_ip_address]
}