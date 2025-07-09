FROM ccarney16/pterodactyl-panel:latest

# Set working directory
WORKDIR /var/www/html

# Set environment variables (external Redis/MySQL)
ENV DB_HOST=turntable.proxy.rlwy.net \
    DB_PORT=37810 \
    DB_DATABASE=railway \
    DB_USERNAME=root \
    DB_PASSWORD=USLmfFkToqgYxLFOiVSTfNgLMDAnKPkX \
    REDIS_HOST=yamabiko.proxy.rlwy.net \
    REDIS_PORT=36301 \
    REDIS_PASSWORD=YWokBciGkyqOXcZSZLQdBRdNSxvphSAZ \
    APP_URL=https://yawning-aardwolf-kayceeko-42026943.koyeb.app \
    CACHE_DRIVER=redis \
    QUEUE_CONNECTION=redis \
    SESSION_DRIVER=redis \
    APP_ENV=production \
    APP_KEY=base64:7FbTQz8kW1sK0dcmShODKdYg+dummykeyplaceholder== \
    APP_TIMEZONE=Africa/Lagos

# Ensure required directories exist and have correct permissions
RUN mkdir -p storage/logs bootstrap/cache \
 && chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# Run Laravel setup commands
RUN php artisan migrate --force && \
    php artisan p:user:make \
        --email=Sakinlolu26@gmail.com \
        --username=admin \
        --name="Admin" \
        --password=Samuel234 \
        --admin=1 && \
    php artisan queue:restart
