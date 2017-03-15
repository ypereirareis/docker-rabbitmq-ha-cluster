FROM zolweb/php7:2.2-alpine

# Install tools...
RUN set -x \
    && docker-php-ext-install bcmath \
    && pecl install amqp