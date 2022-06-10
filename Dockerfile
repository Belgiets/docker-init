FROM php:7.4-apache

RUN a2enmod rewrite

RUN apt-get update \
  && apt-get install -y libzip-dev git wget --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && pecl install xdebug \
  && docker-php-ext-install pdo mysqli pdo_mysql zip \
    && docker-php-ext-enable xdebug

RUN rm -rf /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN wget https://getcomposer.org/download/2.0.9/composer.phar \
    && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer

COPY ./apache/apache.conf /etc/apache2/sites-enabled/000-default.conf
#COPY ./shop /var/www
COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www

CMD ["apache2-foreground"]
