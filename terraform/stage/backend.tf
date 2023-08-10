terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "b1gk5pck1n1mtgfoijib"
    region     = "ru-central1"
    key        = "stage/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
