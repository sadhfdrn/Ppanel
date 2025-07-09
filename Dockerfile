FROM ccarney16/pterodactyl-panel:latest

# Set environment variables
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

# Pre-run setup commands
RUN php artisan migrate --force && \
    php artisan p:user:make \
      --email=Sakinlolu26@gmail.com \
      --username=admin \
      --name="Admin" \
      --password=Samuel234 \
      --admin=1 && \
    php artisan queue:restart
