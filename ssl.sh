#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check for at least one domain name
if [ "$#" -lt "1" ]; then
    echo "Usage: $0 domain1.com domain2.com" >&2
    exit 1
fi


# Validate each domain and subdomain
for domain in "$@"; do
    if ! [[ $domain =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Invalid domain name: $domain" >&2
        exit 1
    fi
done

# Store domains in a variable
domains=("$@")

# Install Certbot and its Nginx plugin if not already installed
if ! command -v certbot > /dev/null 2>&1; then
    echo "Certbot not found, installing it..."
    snap install core; snap refresh core
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot
fi

if ! certbot --nginx -v > /dev/null 2>&1; then
    echo "Certbot Nginx plugin not found, installing it..."
    apt-get update
    apt-get install -y python3-certbot-nginx
fi

# Generate Let's Encrypt certificates for the domains
for domain in "${domains[@]}"; do
    echo "Generating Let's Encrypt certificate for $domain..."
    certbot --nginx -d "$domain" --non-interactive --agree-tos -m your-email@example.com --redirect
    if [ $? -ne 0 ]; then
        echo "Failed to generate certificate for $domain" >&2
        exit 1
    fi
done

echo "Certificates generated successfully."
