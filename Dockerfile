ARG BASE_IMAGE=php:8.2-fpm

FROM ${BASE_IMAGE} AS builder

LABEL maintainer="Alexandre Marinho <alexandre.marinho@nti.ufal.br>"

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libmagickwand-dev \
    gosu \
    sendmail \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    gd \
    exif \
    intl \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd php \
    && useradd -l -g php php

COPY custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]
