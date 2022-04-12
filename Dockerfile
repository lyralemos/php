ARG BASE_IMAGE=php:7.4-fpm

FROM ${BASE_IMAGE}

LABEL maintainer="Alexandre Marinho <alexandre.marinho@nti.ufal.br>"

RUN apt-get update -y &&\
    apt-get install -y gosu sendmail libpng-dev zlib1g-dev libzip-dev libmagickwand-dev &&\
    docker-php-ext-install mysqli pdo pdo_mysql zip gd exif intl &&\
    pecl install imagick &&\
    docker-php-ext-enable imagick &&\
    groupadd php &&\
    useradd -l -g php php

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]