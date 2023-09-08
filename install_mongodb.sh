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
