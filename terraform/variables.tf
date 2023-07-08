variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private key used for ssh access"
}

variable "image_id" {
  description = "Disk image"
}

variable "subnet_id" {
  description = "Subnet"
}

variable "service_account_key_file" {
  description = "Key .json"
}

variable "token" {
  description = "Yandex token"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "Number of instances"
}

variable "vm_name_pfx" {
  type = string
}

variable "external_ip_address" {
  type    = list(string)
  default = []
}