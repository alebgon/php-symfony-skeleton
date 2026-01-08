FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    icu-dev \
    libzip-dev \
    oniguruma-dev

## ---- Xdebug ----
#RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug \
#
#COPY etc/xdebug-config.ini /usr/local/etc/php/conf.d/xdebug-config.ini

RUN docker-php-ext-install \
    intl \
    mbstring \
    zip \
    pdo_mysql \
    opcache

RUN docker-php-ext-install opcache
COPY etc/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

#RUN echo "access.log = /dev/null" >> /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www
