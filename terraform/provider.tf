/* 
  terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.94.0"
    }
  }
  required_version = ">= 0.12"
}
*/

provider "yandex" {
  # token = var.token
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "0.35.0"
} 

/*
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = "my_access_key"
  secret_key = "my_secret_key"
  version = "3.0.0"
}
*/
