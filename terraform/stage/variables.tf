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

variable "db_image_id" {
  type        = string
  description = "Disk image for reddit app"
  default = "reddit-db-base"
}

variable "app_image_id" {
  type        = string
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}

variable "subnet_id" {
  type        = string
  description = "Subnets for modules"
}

variable "service_account_key_file" {
  type        = string
  description = "Key .json"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of instances"
}

variable "external_ip_address" {
  type    = list(string)
  default = []
}
