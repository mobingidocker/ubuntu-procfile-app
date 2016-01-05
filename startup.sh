#!/bin/bash
echo "installing" > /var/log/container_status

echo "Running init script"
bash /tmp/init/init.sh

echo "Installing..."
rm -rf /app
cp -r /code /app


if [[ $BUILDPACK ]]; then
	echo "Custom buildpack $BUILDPACK specified."
	echo "export BUILDPACK_URL=$BUILDPACK" > /app/.env
fi

/build/builder

if [ ! -f /app/Procfile ]; then
    echo "No Procfile found! Will attempt to run with default Procfile if there is any"
fi

mkdir -p /app/.profile.d

if [[ $BUILDPACK ]] && [ -f /app/.release ]; then
	# in case its an old buildpack, we need to read .release
	ruby -e 'require "yaml"; YAML.load_file("/app/.release")["config_vars"].each {|k,v| if k == "PATH"; puts "export #{k}=$#{k}:#{v}"; else; puts "export #{k}=\"#{v}\""; end }' > /app/.profile.d/mocloud_profile.sh 
fi

HOME=/app source /app/.profile.d/*

echo "Installation complete!"

echo "complete" > /var/log/container_status

/usr/bin/supervisord
