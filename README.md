[![Build Status](https://travis-ci.com/aasdhajkshd/infra.svg?branch=master)](https://travis-ci.com/aasdhajkshd/infra)

# aasdhajkshd_infra
AAsdhajkshD Infra repository

---

## Работа с ролями и окружениями Ansible
#### Выполненные работы

1. Создана ветка **ansible-3**
2. Перенесены созданные плейбуки в раздельные роли и с помощью **ansible-galaxy** созданы заготовки
3. Внесены изменения в плейбуки db, app, deploy
4. Проверена работа ролей
5. Изменен **ansible.cfg** с указанием переменных окружения для сред **prod** и **stage**
6. Органиваны плейбуки директории *ansible*
7. Добавлена community роль на примере **jdauphant.nginx**
8. Проверена работа с окружениями, где добавлен **users.yml** плейбук с использованием **ansible-vault**
9. Проверяем функционал

#### Задание со 'star'
1. Для использования динамического инвентори был указан в **ansible.cfg** файл *inventory.json*
2. Для прохожденим валидации в **travis** файл *inventory.json* скопирован в *inventory.sh*

#### Задание со '2star'
1. Добавлен файл **.travis.yml**
2. Выполнил регистрацию на с учетной записью в GitHub https://www.travis-ci.com/
3. Добавлена загрузка и проверка:
```
packer validate
terraform validate
tflint для окружений stage и prod
ansible-lint для плейбуков Ansible
```
1. Добавлен в **README.md** badge со статусом build'а (We are unable to start your build at this time. You exceeded the number of users allowed for your plan. Please review your plan details and follow the steps to resolution.)
2. Репозиториый клонировал в локальный и производится тестирование в Travis CI.
3. TryTravis README.md гласит: This package is no longer maintained. Do not use it. https://github.com/sethmlarson/trytravis
