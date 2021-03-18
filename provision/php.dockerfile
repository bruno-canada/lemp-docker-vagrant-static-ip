ARG CONFIG_PHP_VERSION
ARG CONFIG_PHP_DOCKER_IMAGE

FROM php:${CONFIG_PHP_VERSION}-${CONFIG_PHP_DOCKER_IMAGE}

# Make config args persistent
ARG CONFIG_LOCAL
ARG CONFIG_DESTINATION
ENV CONFIG_LOCAL=${CONFIG_LOCAL}
ENV CONFIG_DESTINATION=${CONFIG_DESTINATION}

# Install xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.discover_client_host = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN addgroup -g 998 www && adduser -G www -g www -s /bin/sh -D www

ADD ./provision/php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN echo $CONFIG_DESTINATION
RUN mkdir -p $CONFIG_DESTINATION

RUN chown -R www:www $CONFIG_DESTINATION
RUN chmod -R 0770 $CONFIG_DESTINATION

WORKDIR $CONFIG_DESTINATION

RUN docker-php-ext-install pdo pdo_mysql

