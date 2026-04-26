FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    zip unzip libzip-dev \
    oniguruma-dev \
    icu-dev \
    gettext-dev \
    libxml2-dev \
    curl-dev \
    autoconf g++ make linux-headers \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    mysqli \
    pdo_mysql \
    gd \
    mbstring \
    curl \
    xml \
    zip \
    intl \
    gettext \
    opcache

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY www.conf /usr/local/etc/php/pool.d/www.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /var/www/html
