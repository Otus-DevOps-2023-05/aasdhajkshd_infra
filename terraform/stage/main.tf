module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_image_id   = var.app_image_id
  subnet_id        = var.subnet_id
  cloud_id         = var.cloud_id
  folder_id        = var.folder_id
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  db_image_id    = var.db_image_id
  subnet_id        = var.subnet_id
  cloud_id         = var.cloud_id
  folder_id        = var.folder_id
}
