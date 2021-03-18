#!/usr/bin/env bash

# Change DNS records to Cloudflare
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf

# Install base packages
# apk update

# Install docker
apk add docker-compose docker

# Handle groups and permissions
adduser vagrant docker

# Add docker and docker-compose to boot
rc-update add docker

# Reboot services
rc-service docker restart

