# Use the official PHP 8.3 image
FROM php:8.3-fpm

# Install necessary dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    libpq-dev \
    libzip-dev \
    libssl-dev \
    libonig-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pgsql pdo pdo_pgsql zip mbstring gd \
    && rm -rf /var/lib/apt/lists/*
	
# Install the pcntl extension
RUN docker-php-ext-install pcntl

# Install the Swoole extension for PHP
RUN pecl install swoole && docker-php-ext-enable swoole

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 for the application
EXPOSE 9000

# Run Octane (Swoole)
CMD ["php", "artisan", "octane:start"]