FROM php:7.2-apache

# Install unzip
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    libmemcached11 \
    libc-client-dev \
    zip \
    unzip \
    libzip-dev \
    libmemcached-dev \
    libcurl4-openssl-dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip
RUN pecl install memcached
RUN docker-php-ext-enable memcached

COPY wordpress/ .

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini
