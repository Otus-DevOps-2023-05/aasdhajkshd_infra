source "yandex" "test" {
  service_account_key_file = var.key_file
  folder_id           = var.folder_id
  subnet_id           = var.subnet_id
  source_image_family = "ubuntu-1604-lts"
  image_name          = "reddit-base-{{timestamp}}"
  image_family        = "reddit-base"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  use_internal_ip     = "false"
  max_retries         = "5"
  platform_id         = var.platform_id
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

}
