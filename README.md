# aasdhajkshd_infra
aasdhajkshd Infra repository

# Добавим следующие ключи
ssh-keygen -t rsa -b 2048 -C appuser@yc -f ~/.ssh/appuser

# Создадим конфигурационный файл
cat << EOF > ~/.ssh/config
Host *
    ServerAliveInterval 300
    ServerAliveCountMax 2
    User appuser
    Port 22
    IdentityFile ~/.ssh/appuser
Host someinternalhost
    HostName 10.128.0.17
    ProxyJump 51.250.1.205
host bastion
    HostName 51.250.1.205
    IdentityFile ~/.ssh/appuser
EOF

# Выполним команду
for i in bastion someinternalhost; do echo "Hostname: $i"; ssh $i ip addr show eth0 | awk '/inet/ { print $2; exit }'; done

# Рузельтат соответствует адресации в облаке
Hostname: bastion
10.128.0.21/24
Hostname: someinternalhost
10.128.0.17/24

# Rонфигурацию и данные для подключения
bastion_IP = 51.250.1.205
someinternalhost_IP = 10.128.0.17
test/Siemens_2023
