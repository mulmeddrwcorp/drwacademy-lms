#!/bin/bash

echo "=== Setup drwacademy.com routing via existing N8N nginx ==="

# Start Academy containers on port 9000
echo "Starting Academy containers..."
docker-compose -f docker-compose.prod.yml up -d

# Wait for containers to be ready
sleep 5

# Find N8N nginx container config path
N8N_CONTAINER="n8n-drw_nginx_1"

echo "Adding Academy routing to N8N nginx configuration..."

# Copy our academy config to the N8N nginx container
docker cp add-to-n8n-nginx.conf $N8N_CONTAINER:/etc/nginx/conf.d/academy.conf

# Test nginx configuration
echo "Testing nginx configuration..."
docker exec $N8N_CONTAINER nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    
    # Reload nginx to apply new configuration
    docker exec $N8N_CONTAINER nginx -s reload
    
    echo "✅ Setup completed!"
    echo ""
    echo "Your websites are now available at:"
    echo "🎓 Academy: http://drwacademy.com (clean URL!)"
    echo "🤖 N8N: http://n8n.drwapp.com (unchanged)"
    echo ""
    echo "Testing connection..."
    sleep 2
    curl -I http://drwacademy.com
    
else
    echo "❌ Nginx configuration error"
    echo "Rolling back..."
    docker exec $N8N_CONTAINER rm -f /etc/nginx/conf.d/academy.conf
fi

echo ""
echo "Current Academy container status:"
docker-compose -f docker-compose.prod.yml ps
