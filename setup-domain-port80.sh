#!/bin/bash

echo "=== Setup Domain drwacademy.com (Port 80) ==="

# Install nginx on host system if not exists
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
fi

# Stop existing nginx to avoid conflicts
sudo systemctl stop nginx

# Copy our nginx configuration
sudo cp server-nginx.conf /etc/nginx/sites-available/drwacademy
sudo ln -sf /etc/nginx/sites-available/drwacademy /etc/nginx/sites-enabled/

# Remove default nginx site
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    
    # Start our academy containers
    docker-compose -f docker-compose.prod.yml down
    docker-compose -f docker-compose.prod.yml up -d
    
    # Wait for containers to be ready
    sleep 10
    
    # Start nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    echo "✅ Setup completed!"
    echo ""
    echo "Your website is now available at:"
    echo "🌐 http://drwacademy.com (no port needed!)"
    echo "🔧 Admin/N8N: http://n8n.drwacademy.com (optional subdomain)"
    echo ""
    echo "Current status:"
    docker-compose -f docker-compose.prod.yml ps
    sudo systemctl status nginx --no-pager -l
    
else
    echo "❌ Nginx configuration error. Please check the config."
fi
