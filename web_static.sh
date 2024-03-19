#!/usr/bin/env bash

# Update and Install Dependencies
apt-get update -q && apt-get install -y nginx -q

# Create Directories and Files
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/
touch /data/web_static/releases/test/index.html
echo "Hello World again!" > /data/web_static/releases/test/index.html

# Manage Symbolic Link
if [ -d "/data/web_static/current" ] && [ -z "$(ls -A /data/web_static/current)" ]; then
  rm -rf /data/web_static/current
fi
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change ownership to user ubuntu
chown -hR ubuntu:ubuntu /data

# Configure nginx
sed -i '38i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

# Restart server
service nginx restart
