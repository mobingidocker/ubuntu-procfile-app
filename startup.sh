#!/bin/bash
echo "installing" > /var/log/container_status

echo "Installing..."
/build/builder

if [ ! -f /app/Procfile ]; then
    echo "No Procfile found! Will attempt to run with default Procfile if there is any"
fi

echo "Running init script"
bash /tmp/init/init.sh

HOME=/app source /app/.profile.d/*

echo "Installation complete!"

echo "complete" > /var/log/container_status

/usr/bin/supervisord
