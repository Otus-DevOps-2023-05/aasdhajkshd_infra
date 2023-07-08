# aasdhajkshd_infra
aasdhajkshd Infra repository

## лог создания terraform виртуальных машин
> terraform/terraform.log

## балансировщик
> код в main.tf закомментирован, lb.tf

## count
> найдено решение в блоке connection использовать self.network_interface[0].nat_ip_address, чтобы обойти проблему цикла при terraform plan

## .gitignore
```text
terraform/.gitignore 
**/key.json
key.json
/.secrets/*
secrets.*
*.tfstate
*.tfstate.*
*.tfstate.*.backup
*.tfstate.backup
*.tfvars
.terraform/
/.terraform/*
.terraform.lock.hcl
crash.log
crash.*.log
*.tfvars
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
```
