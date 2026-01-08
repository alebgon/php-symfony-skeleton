FROM --platform=$BUILDPLATFORM php:8.4-cli-alpine

RUN apk add --no-cache \
    git \
    openssh \
    unzip \
    bash \
    icu-dev \
    libzip-dev \
    linux-headers \
    oniguruma-dev \
    $PHPIZE_DEPS

# ---- Xdebug ----
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY etc/xdebug-config.ini /usr/local/etc/php/conf.d/xdebug-config.ini

RUN docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    mbstring \
    zip

# ---- Install Composer ----
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
