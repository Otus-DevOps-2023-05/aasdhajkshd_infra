variable "key_file" {
  type    = string
  default = "../.secrets/packer.json"
}

variable "scripts_folder" {
  type    = string
  default = "scripts"
}

variable "folder_id" {
  type    = string
  default = "b1g0da3u1gqk0nansi59"
}

variable "subnet_id" {
  type    = string
  default = "e9bi9oji8ljojstbt6cp"
}

variable "platform_id" {
  type = string
  default = "standard-v1"
}
