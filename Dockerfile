FROM php:7.4-apache

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install additional extensions that might be needed
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Copy Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install PHP dependencies if composer.json exists
RUN if [ -f composer.json ]; then composer install --no-dev --optimize-autoloader; fi

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Create writable directories for CodeIgniter
RUN mkdir -p /var/www/html/application/logs
RUN mkdir -p /var/www/html/application/cache
RUN chmod -R 777 /var/www/html/application/logs
RUN chmod -R 777 /var/www/html/application/cache
RUN chmod -R 777 /var/www/html/uploads

EXPOSE 80

CMD ["apache2-foreground"]
