variable "cloud_id" {
  type        = string
  description = "Cloud"
}

variable "folder_id" {
  type        = string
  description = "Folder"
}

variable "zone" {
  type        = string
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
  type        = string
  description = "Disk image"
}

variable "subnet_id" {
  type        = string
  description = "Subnet"
}

variable "service_account_key_file" {
  type        = string
  description = "Key .json"
}

variable "token" {
  type        = string
  description = "Yandex token"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of instances"
}

variable "vm_name_pfx" {
  type = string
}

variable "external_ip_address" {
  type    = list(string)
  default = []
}