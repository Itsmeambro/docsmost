# Base image: use an appropriate base (e.g., Debian/Ubuntu)
FROM ubuntu:20.04

ENV TZ=America/New_York  

# Install necessary dependencies (Node.js, PostgreSQL, Redis, etc.)
RUN apt-get update && \
    apt-get install -y \
    postgresql redis-server curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \ 
    dpkg-reconfigure -f noninteractive tzdata

# Install docmost (assuming it's a Node.js application)
RUN npm install -g docmost

# Set environment variables for PostgreSQL and Redis
ENV POSTGRES_DB=docmost \
    POSTGRES_USER=docmost \
    POSTGRES_PASSWORD=HpKm6jar9T \
    APP_URL=http://localhost:3000 \
    APP_SECRET=TW3kJSO4HMdwq8Vlc0L8ZRCIZxtO4R \
    DATABASE_URL=postgresql://docmost:HpKm6jar9T@localhost:5432/docmost?schema=public \
    REDIS_URL=redis://localhost:6379

# Expose necessary ports
EXPOSE 3000 5432 6379

# Create directories for volumes
VOLUME ["/app/data/storage", "/var/lib/postgresql/data", "/data"]

# Use supervisord to manage multiple services
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Entry point to start all services
CMD ["/usr/bin/supervisord"]  add
