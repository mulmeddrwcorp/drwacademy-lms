#!/bin/bash

# SSL Setup Script with Let's Encrypt
# Usage: ./setup-ssl.sh yourdomain.com

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 academy.yourdomain.com"
    exit 1
fi

echo "Setting up SSL for domain: $DOMAIN"

# Install certbot if not exists
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    sudo apt update
    sudo apt install -y certbot
fi

# Stop nginx temporarily
docker-compose -f docker-compose.prod.yml stop nginx

# Get SSL certificate
echo "Obtaining SSL certificate for $DOMAIN..."
sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN --email admin@$DOMAIN --agree-tos --non-interactive

# Copy certificates to nginx ssl directory
sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ./nginx/ssl/$DOMAIN.crt
sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ./nginx/ssl/$DOMAIN.key
sudo chown $(whoami):$(whoami) ./nginx/ssl/$DOMAIN.*

# Update nginx configuration
sed -i "s/yourdomain.com/$DOMAIN/g" ./nginx/sites/default.conf

# Uncomment HTTPS configuration
sed -i 's/# server {/server {/g' ./nginx/sites/default.conf
sed -i 's/# \(.*\)/\1/g' ./nginx/sites/default.conf

# Comment out HTTP direct serving and uncomment HTTPS redirect
sed -i 's/^    location \/ {/    # location \/ {/' ./nginx/sites/default.conf
sed -i 's/^    # return 301/    return 301/' ./nginx/sites/default.conf

# Start nginx
docker-compose -f docker-compose.prod.yml up -d nginx

echo "SSL setup completed for $DOMAIN"
echo "Your website is now available at: https://$DOMAIN"

# Setup auto-renewal
echo "Setting up auto-renewal..."
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

echo "Auto-renewal set up. Certificates will renew automatically."
