#!/bin/bash

echo "=== Setup Domain drwacademy.com ==="

# Stop existing containers
echo "Stopping existing containers..."
docker-compose down

# Build and start with Nginx production setup
echo "Starting production setup with Nginx..."
docker-compose -f docker-compose.prod.yml up --build -d

echo "✅ Domain setup completed!"
echo ""
echo "Next steps:"
echo "1. Point your DNS:"
echo "   A record: drwacademy.com → YOUR_SERVER_IP"
echo "   A record: www.drwacademy.com → YOUR_SERVER_IP"
echo ""
echo "2. Test HTTP access:"
echo "   http://drwacademy.com"
echo ""
echo "3. Setup SSL certificate:"
echo "   ./setup-ssl.sh drwacademy.com"
echo ""
echo "4. After SSL setup, your site will be available at:"
echo "   https://drwacademy.com"
echo ""
echo "Current status:"
docker-compose -f docker-compose.prod.yml ps
