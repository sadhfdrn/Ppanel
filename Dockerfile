FROM ccarney16/pterodactyl-panel:latest

# Set environment variables for external database and Redis
ENV DB_CONNECTION=mysql
ENV DB_HOST=turntable.proxy.rlwy.net
ENV DB_PORT=37810
ENV DB_DATABASE=railway
ENV DB_USERNAME=root
ENV DB_PASSWORD=USLmfFkToqgYxLFOiVSTfNgLMDAnKPkX

# Redis configuration
ENV REDIS_HOST=yamabiko.proxy.rlwy.net
ENV REDIS_PORT=36301
ENV REDIS_PASSWORD=YWokBciGkyqOXcZSZLQdBRdNSxvphSAZ

# Cache and session configuration
ENV CACHE_DRIVER=redis
ENV SESSION_DRIVER=redis
ENV QUEUE_DRIVER=redis

# App configuration
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_URL=https://yawning-aardwolf-kayceeko-42026943.koyeb.app
ENV APP_TIMEZONE=UTC

# Mail configuration (optional - configure if needed)
ENV MAIL_DRIVER=smtp
ENV MAIL_HOST=smtp.gmail.com
ENV MAIL_PORT=587
ENV MAIL_USERNAME=your-email@gmail.com
ENV MAIL_PASSWORD=your-app-password
ENV MAIL_ENCRYPTION=tls
ENV MAIL_FROM_ADDRESS=your-email@gmail.com
ENV MAIL_FROM_NAME="Pterodactyl Panel"

# Trusted proxies for Koyeb
ENV TRUSTED_PROXIES=*

# Set working directory
WORKDIR /app

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose port 80 for Koyeb
EXPOSE 80

# Start the application with our custom startup script
CMD ["/startup.sh"]
