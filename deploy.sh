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
