ARG BASE_IMAGE=php:7.4-fpm

FROM ${BASE_IMAGE}

LABEL maintainer="Alexandre Marinho <alexandre.marinho@nti.ufal.br>"

RUN apt-get update -y &&\
    apt-get install -y sendmail libpng-dev zlib1g-dev libzip-dev &&\
    docker-php-ext-install mysqli pdo pdo_mysql zip gd &&\
    groupadd php &&\
    useradd -l -g php php

USER php