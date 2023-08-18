source "yandex" "test" {
  service_account_key_file = var.key_file
  folder_id           = "b1g0da3u1gqk0nansi59"
  source_image_family = "ubuntu-1604-lts"
  image_name          = "reddit-base-{{timestamp}}"
  image_family        = "reddit-base"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  use_internal_ip     = "false"
  max_retries         = "5"
  platform_id         = "standard-v1"
  subnet_id           = "e9bi9oji8ljojstbt6cp"
}

build {
  sources  = ["source.yandex.test"]

  provisioner "shell" {
    inline = [
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get update",
      "sudo apt install -q -y dialog rsync dos2unix git telnet",
      "sudo apt upgrade -y"
    ]
    pause_before    = "5s"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    scripts          = ["${var.scripts_folder}/install_mongodb.sh"]
    execute_command = "sudo -s sh -c {{.Path}}"
    timeout         = "5m"
    pause_before    = "30s"
  }

}
