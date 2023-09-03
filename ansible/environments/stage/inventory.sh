#!/bin/bash

server1ip=$(yc compute instances list | awk '{print $10}' | sed '/^[[:space:]]*$/d' |  sed  '1d' | head -1)
server1host=$(yc compute instances list | awk '{print $4}' | sed '/^[[:space:]]*$/d' |  sed  '1d' | head -1)
server2ip=$(yc compute instances list | awk '{print $10}' | sed '/^[[:space:]]*$/d' |  sed  '1d' | tail -1)
server2host=$(yc compute instances list | awk '{print $4}' | sed '/^[[:space:]]*$/d' |  sed  '1d' | tail -1)

if [ "${server1host:7:-2}" == "db" ]; then
	db_ip=$server1ip
else
	db_ip=$server2ip
fi

if [ "$1" == "--list" ] ; then
cat<<EOF
{
  "${server1host:7:-2}": {
	"hosts": ["$server1ip"],
	"vars": {
		"db_ip": "$db_ip"
	}
  },
  "${server2host:7:-2}": {
  	"hosts": ["$server2ip"],
  	"vars": {
  		"db_ip": "$db_ip"
  	}
  },
  "_meta": {
	"hostvars": {
	  "$server1ip": {
		"host_specific_var": "${server1host::-2}"
	  },
	  "$server2ip": {
		"host_specific_var": "${server2host::-2}"
	  }
	}
  }
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
