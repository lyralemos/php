ARG BASE_IMAGE=php:7.4-fpm

FROM ${BASE_IMAGE}

LABEL maintainer="Alexandre Marinho <alexandre.marinho@nti.ufal.br>"

RUN apt-get update -y &&\
    apt-get install -y --no-install-recommends gosu sendmail &&\
    rm -rf /var/lib/apt/lists/* &&\
    savedAptMark="$(apt-mark showmanual)" &&\
    apt-get update -y &&\
    apt-get install -y --no-install-recommends libpng-dev zlib1g-dev libzip-dev libmagickwand-dev &&\
    docker-php-ext-install mysqli pdo pdo_mysql zip gd exif intl &&\
    pecl install imagick &&\
    docker-php-ext-enable imagick &&\
    apt-mark auto '.*' > /dev/null &&\
    apt-mark manual $savedAptMark &&\
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual &&\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
    rm -rf /var/lib/apt/lists/* &&\
    groupadd php &&\
    useradd -l -g php php

COPY custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]