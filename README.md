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

## модули и задание
> выполнено задание "Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform."
> настроена работа с "модулями" в terraform: prod и stage
> основная проблема была в инициализации, но решается добавлением в модуле provider\'а, то есть самого блока terraform { required_providers {...
> видно, что проблема связана с обращением непосредственно к hashicorp и по up level provider.tf файл не наследуется ниже, оно и понятно, так как запуск выполняется из директории ниже уровнем <root>/{prod,stage,s3} и т.д.
> json формат для db и app минимальный, использовался свой ранее написанный на hcl

## дополнительное задание
> выполнено.
> в консоли yandex object виден файл tfstate, который описывается в backend.tf. Из самого файла ключи перед коммитом удалены. После apply и разворачивания машин, состояние доступно, можно снести этот tfstate с backup\'ным.
> одновременно запустить можно, в этом нет проблемы, ошибка на уровне создания "существующего объекта", если только не будет с использованием бэкендов (backend) S3, тогда просто при apply выполняется refresh, так как состояние уже изветно (считывается из хранилища). Тогда доступны блокировки
> provisioner менее интересны, это чисто выполнение скриптов, более интересным было изучение передачи переменных, полученных в ходе исполнения, тут как раз depend_on нужен и через output можно в root передать значение переменной, как IP адрес
> важным нужно учитывать, что с другой стороны необходимо описывать переменные, например, в app/variables.tf значений из db/outputs.tf
