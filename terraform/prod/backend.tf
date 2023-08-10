terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "b1gk5pck1n1mtgfoijib"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEORbqMpUghLYTe_k_3k_j"
    secret_key = "YCMldBRw8ISfi_OZcEWyoQjTr7LZnY-8flQcWPgP"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
