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
