# aasdhajkshd_infra
aasdhajkshd Infra repository

## лог создания terraform виртуальных машин
> terraform/terraform.log

## балансировщик
> код в main.tf закомментирован, lb.tf

## Переменная count должна задается в параметрах
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

## Установлен tflint для проверки terraform файлов
```sh
tflint --var-file=terraform.tfvars.example
```
## Для terraform 0.12+
> чтобы успешно пройти проверку, необходимо закомментировать terraform блок
> согласно документации по Yandex, ранние версии использовали 0.12+, но об этом нет упоминиания в документации, пока не нашел...
> но есть https://registry.terraform.io/providers/hashicorp/aws/latest/docs здесь подсказка

## в корень добавлен бинарный файл terraform версии 0.12.19
> до модулей еще далеко...
