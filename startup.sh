#!/bin/bash
echo "installing" > /var/log/container_status

if [ ! -d "/app" ]; then
	if [ -n "$GIT_REPO" ]; then
		git clone "$GIT_REPO" /app
		/build/builder
	else
		echo "No \$GIT_REPO environment variable defined"
		exit 1
	fi
fi

if [ ! -f /app/Procfile ]; then
    echo "Procfile is not found!"
fi

echo "Running init script"
bash /tmp/init/init.sh

echo "complete" > /var/log/container_status

HOME=/app source /app/.profile.d/*

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
/usr/bin/supervisord
