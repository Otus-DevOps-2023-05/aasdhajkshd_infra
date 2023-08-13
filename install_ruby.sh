#!/bin/bash
sudo apt update && \
	sudo apt install -y ruby-full ruby-bundler build-essential git
if [[ $(echo $? > /dev/null) -ne 0 ]];
	echo "Huston, we've got a problem with Ruby install!"
	exit 1
else
	echo -e "We've installed: \nRuby: $(ruby -v)\nBundle: $(bundle -v)"
fi
exit 0
