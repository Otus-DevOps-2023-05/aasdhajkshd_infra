output "external_ip_address_db" {
  value = [for instance in yandex_compute_instance.reddit-db : instance.network_interface[*].nat_ip_address]
}
output "internal_ip_address_db" {
  value = [for instance in yandex_compute_instance.reddit-db : instance.network_interface[*].ip_address]
}
