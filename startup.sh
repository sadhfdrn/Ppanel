#!/bin/bash

# Pterodactyl Panel Startup Script for Koyeb
# This script runs automatically when the container starts

echo "Starting Pterodactyl Panel setup..."
echo "Database Host: $DB_HOST"
echo "Database Port: $DB_PORT"
echo "Database Name: $DB_DATABASE"
echo "Database User: $DB_USERNAME"

# Test basic connectivity first
echo "Testing database connectivity..."
timeout 30 bash -c "until nc -z $DB_HOST $DB_PORT; do sleep 1; done" && echo "Database port is reachable" || echo "Database port is not reachable"

# Try connecting with mysql client directly
echo "Testing MySQL connection..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" -e "SELECT 1;" 2>&1 | head -5

# Wait for database to be ready with Laravel
echo "Waiting for Laravel database connection..."
max_attempts=20
attempt=0

until timeout 15 php /app/artisan migrate:status > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "Database connection failed after $max_attempts attempts"
        echo "Last error:"
        php /app/artisan migrate:status 2>&1 | tail -10
        exit 1
    fi
    echo "Database not ready, waiting 15 seconds... (attempt $attempt/$max_attempts)"
    sleep 15
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
