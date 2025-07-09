#!/bin/bash

# Pterodactyl Panel Startup Script for Koyeb
# This script runs automatically when the container starts

echo "Starting Pterodactyl Panel setup..."

# Wait for database to be ready
echo "Waiting for database connection..."
max_attempts=30
attempt=0

until php /app/artisan migrate:status > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "Database connection failed after $max_attempts attempts"
        exit 1
    fi
    echo "Database not ready, waiting 10 seconds... (attempt $attempt/$max_attempts)"
    sleep 10
done

echo "Database connection established!"

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    echo "Generating application key..."
    php /app/artisan key:generate --force
fi

# Run database migrations
echo "Running database migrations..."
php /app/artisan migrate --force

# Check if admin user already exists
if php /app/artisan p:user:list | grep -q "Sakinlolu26@gmail.com"; then
    echo "Admin user already exists, skipping creation..."
else
    echo "Creating admin user..."
    php /app/artisan p:user:make \
        --email="Sakinlolu26@gmail.com" \
        --username="admin" \
        --name-first="Admin" \
        --name-last="User" \
        --password="Samuel234" \
        --admin=1
fi

# Create default location if it doesn't exist
if ! php /app/artisan p:location:list | grep -q "default"; then
    echo "Creating default location..."
    php /app/artisan p:location:make \
        --short="default" \
        --long="Default Location"
else
    echo "Default location already exists, skipping creation..."
fi

# Clear and cache config
echo "Optimizing application..."
php /app/artisan config:cache
php /app/artisan view:cache
php /app/artisan route:cache

echo "Setup complete!"
echo "Admin login: Sakinlolu26@gmail.com"
echo "Admin password: Samuel234"
echo "Starting supervisord..."

# Start supervisord
exec supervisord -n -c /etc/supervisor/supervisord.conf 
