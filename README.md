# aasdhajkshd_infra
aasdhajkshd Infra repository

# данные для подключения
testapp_IP = 51.250.81.3

testapp_port = 9292

# Пример скрипта install_ruby.sh содержит команды по установке Ruby
```bash
#!/bin/bash
sudo apt update && \
	sudo apt install -y ruby-full ruby-bundler build-essential
if [[ $(echo $? > /dev/null) -ne 0 ]]; then
	echo "!!! Huston, we've got a problem with Ruby install!"
	exit 1
else
	echo -e "### We've installed: \nRuby: $(ruby -v)\nBundle: $(bundle -v)"
fi
exit 0
```

# Пример скрипта install_mongodb.sh содержит команды по установке MongoDB
```bash
#!/bin/bash
curl -fsSL https://pgp.mongodb.com/server-4.4.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-4.4.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update && \
	sudo apt-get install -y mongodb-org
if [[ "$(echo $? > /dev/null)" -eq 0 ]]; then
	sudo systemctl enable mongod; \
		sudo systemctl start mongod
fi
if [[ "$(sudo systemctl is-failed mongod)" != "active" ]]; then
	echo "!!! Something went wrong with mongod service"
	systemctl status mongod
	exit 1
else
	echo "### Mongod server is up and running..."
	exit 0
fi
```

# Пример скрипта deploy.sh содержит команды скачивания кода, установки зависимостей через bundler и запуск приложения.
```bash
#!/bin/bash
sh ./install_ruby.sh
sh ./install_mongodb.sh

cd $HOME;
[[ "$(which git > /dev/null; echo $?)" -eq 0 ]] || \
	sudo apt-get install -y git

git clone -b monolith https://github.com/express42/reddit.git
[[ "$echo $?" -eq 0 ]] || echo "Ohh, git, my git"

cd reddit && bundle install
puma -d
sleep 5

if [[ "$(ss -ant "sport = :9292" | tail -n +2 | awk '{ print $4 }')" == "*:9292" ]]; then
	echo "### Puma server is running";
	ps aux | grep -v grep | grep puma
	exit 0
else
	echo "!!! Deployment failed, check it..."
	exit 1
fi
```

# Не забыть сделать запускаемыми скрипты
```bash
chmod +x install_*.sh deploy.sh
```

# Можно воспользоваться cloud-init скриптом init.sh

```bash
#!/bin/bash
if [[ "$(ss -ant "sport = :9292" | tail -n +2 | awk '{ print $4 }')" == "*:9292" ]]; then
	echo "### Puma server is running";
	ps aux | grep -v grep | grep puma
	exit 0
fi

curl -fsSL https://pgp.mongodb.com/server-4.4.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-4.4.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update && \
	sudo apt-get install -y mongodb-org ruby-full ruby-bundler build-essential git rsync dos2unix
if [[ "$(echo $? > /dev/null)" -eq 0 ]]; then
	sudo systemctl enable mongod; \
		sudo systemctl start mongod
fi
if [[ "$(sudo systemctl is-failed mongod)" != "active" ]]; then
	echo "!!! Something went wrong with mongod service"
	systemctl status mongod
else
	echo "### Mongod server is up and running..."
fi

[[ "$(which git > /dev/null; echo $?)" -eq 0 ]] || \
	sudo apt-get install -y

sudo mkdir -p /data

git clone -b monolith https://github.com/express42/reddit.git /data/reddit
[[ "$echo $?" -eq 0 ]] || echo "Ohh, git, my git"

sudo chown reddit:reddit -R /data

echo "We are now in $(pwd)..."
cd /data/reddit && \
	bundle install

if [[ $(echo $?) -ne 0 ]]; then
	echo "!!! Deployment failed, check it..."
	exit 1
fi
exit 0
```

# Из этого файла получаем b64 и вставляем в user-data
```bash
cat init.sh | base64 | tr -d '\n'
```

# Файл reddit-app.yaml
```yaml
#cloud-config
package_update: false
package_upgrade: false
users:
  - name: appuser
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxAzVxg3K3JJ0Tpsw+Qs+N2/IKNR2mfhcUT8Whdpzeby7/BOxS6HmydwD01YxFBJQgXi07Mj7RkplyOIz+wc7sZtPGQ9Ju9/2b9zVbM+T5WAO2hPlv38IeJMKRRG3RttYXeS3OfjfegkvwYorpCP3VgDaDp6xu2GQ3G3mESkh/DNjnH6oaYexSQ+GL9AU7k14vNwjK57su5ARn/dUbJln7F4RdFjL2++tZRGp6RGKEIf4KdZamA5SUsRkqwr6hJWQcpaRKLucBK8RSQGCEODVPZIDZ9/VHU1rJwGeKHuNKeLQjChfj1H4WkIOAS7q+x8rNCa4ZAZL+sL6kTuftNFMp appuser@yc
  - name: reddit
    passwd: $6$VMB6iWdM$V/Pw803Xly5/.rrEje5ngDTN9vbBfVpNoWUomES0UFDQ9r1uc6119iuayG85D13rkJbj042xbsJXgsvMaI5ps/
    shell: /bin/bash
write_files:
  - encoding: b64
    content: IyEvYmluL2Jhc2gKaWYgW1sgIiQoc3MgLWFudCAic3BvcnQgPSA6OTI5MiIgfCB0YWlsIC1uICsyIHwgYXdrICd7IHByaW50ICQ0IH0nKSIgPT0gIio6OTI5MiIgXV07IHRoZW4KCWVjaG8gIiMjIyBQdW1hIHNlcnZlciBpcyBydW5uaW5nIjsKCXBzIGF1eCB8IGdyZXAgLXYgZ3JlcCB8IGdyZXAgcHVtYQoJZXhpdCAwCmZpCgkKY3VybCAtZnNTTCBodHRwczovL3BncC5tb25nb2RiLmNvbS9zZXJ2ZXItNC40LmFzYyB8IHN1ZG8gZ3BnIC1vIC91c3Ivc2hhcmUva2V5cmluZ3MvbW9uZ29kYi1zZXJ2ZXItNC40LmdwZyAtLWRlYXJtb3IKZWNobyAiZGViIFsgYXJjaD1hbWQ2NCxhcm02NCBzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9tb25nb2RiLXNlcnZlci00LjQuZ3BnIF0gaHR0cHM6Ly9yZXBvLm1vbmdvZGIub3JnL2FwdC91YnVudHUgeGVuaWFsL21vbmdvZGItb3JnLzQuNCBtdWx0aXZlcnNlIiB8IHN1ZG8gdGVlIC9ldGMvYXB0L3NvdXJjZXMubGlzdC5kL21vbmdvZGItb3JnLTQuNC5saXN0CnN1ZG8gYXB0LWdldCB1cGRhdGUgJiYgXAoJc3VkbyBhcHQtZ2V0IGluc3RhbGwgLXkgbW9uZ29kYi1vcmcgcnVieS1mdWxsIHJ1YnktYnVuZGxlciBidWlsZC1lc3NlbnRpYWwgZ2l0IHJzeW5jIGRvczJ1bml4CmlmIFtbICIkKGVjaG8gJD8gPiAvZGV2L251bGwpIiAtZXEgMCBdXTsgdGhlbgoJc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIG1vbmdvZDsgXAoJCXN1ZG8gc3lzdGVtY3RsIHN0YXJ0IG1vbmdvZApmaQppZiBbWyAiJChzdWRvIHN5c3RlbWN0bCBpcy1mYWlsZWQgbW9uZ29kKSIgIT0gImFjdGl2ZSIgXV07IHRoZW4KCWVjaG8gIiEhISBTb21ldGhpbmcgd2VudCB3cm9uZyB3aXRoIG1vbmdvZCBzZXJ2aWNlIgoJc3lzdGVtY3RsIHN0YXR1cyBtb25nb2QKZWxzZQoJZWNobyAiIyMjIE1vbmdvZCBzZXJ2ZXIgaXMgdXAgYW5kIHJ1bm5pbmcuLi4iCmZpCgpbWyAiJCh3aGljaCBnaXQgPiAvZGV2L251bGw7IGVjaG8gJD8pIiAtZXEgMCBdXSB8fCBcCglzdWRvIGFwdC1nZXQgaW5zdGFsbCAteSAKCQpzdWRvIG1rZGlyIC1wIC9kYXRhCgpnaXQgY2xvbmUgLWIgbW9ub2xpdGggaHR0cHM6Ly9naXRodWIuY29tL2V4cHJlc3M0Mi9yZWRkaXQuZ2l0IC9kYXRhL3JlZGRpdApbWyAiJGVjaG8gJD8iIC1lcSAwIF1dIHx8IGVjaG8gIk9oaCwgZ2l0LCBteSBnaXQiCgpzdWRvIGNob3duIHJlZGRpdDpyZWRkaXQgLVIgL2RhdGEKCmVjaG8gIldlIGFyZSBub3cgaW4gJChwd2QpLi4uIgpjZCAvZGF0YS9yZWRkaXQgJiYgXAoJYnVuZGxlIGluc3RhbGwKCmlmIFtbICQoZWNobyAkPykgLW5lIDAgXV07IHRoZW4KCWVjaG8gIiEhISBEZXBsb3ltZW50IGZhaWxlZCwgY2hlY2sgaXQuLi4iCglleGl0IDEKZmkKZXhpdCAw
    owner: appuser:appuser
    path: /opt/init.sh
    permissions: '0755'
  - encoding: b64
    content: ZGViIFsgYXJjaD1hbWQ2NCxhcm02NCBzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9tb25nb2RiLXNlcnZlci00LjQuZ3BnIF0gaHR0cHM6Ly9yZXBvLm1vbmdvZGIub3JnL2FwdC91YnVudHUgeGVuaWFsL21vbmdvZGItb3JnLzQuNCBtdWx0aXZlcnNlCg==
    path: /etc/apt/sources.list.d/mongodb-org-4.4.list
    permissions: '0644'
runcmd:
  - [ sh, -xc, "echo $(date) ': Hello, World!'" ]
  - [ /opt/init.sh ]
  - su - reddit -s /bin/bash -c "cd /data/reddit && puma -d"
  - sed -i '/^exit 0/i su - reddit -s /bin/bash -c "cd /data/reddit && puma -d"' /etc/rc.local
```

# Команда для удаления instance
```bash
yc compute instance delete --name reddit-app
```

# Команда для создания instance для установки скриптов вручную
```bash
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key ~/.ssh/appuser.pub
```

# Команда для создания instance с уже запущенным приложением

```bash
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --metadata-from-file user-data=reddit-app.yaml
```

