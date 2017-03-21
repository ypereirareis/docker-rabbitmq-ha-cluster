FROM zolweb/php7:2.2-alpine

ENV RABBITMQ_C_VER 0.8.0

RUN set -xe && \
    apk add --update \
        wget \
        autoconf \
        cmake \
        build-base \
        openssl-dev \

# RabbitMQ C client
&& wget -qO- https://github.com/alanxz/rabbitmq-c/releases/download/v${RABBITMQ_C_VER}/rabbitmq-c-${RABBITMQ_C_VER}.tar.gz \
        | tar xz -C /tmp/ && \
    cd /tmp/rabbitmq-c-${RABBITMQ_C_VER} && \
    mkdir -p build && cd build && \
    cmake .. \
    		-DCMAKE_INSTALL_PREFIX=/usr \
    		-DCMAKE_INSTALL_LIBDIR=lib \
    		-DCMAKE_C_FLAGS="$CFLAGS" && \
    cmake --build . --target install

# Install tools...
RUN set -x \
    && docker-php-ext-install bcmath pcntl \
    && pecl install amqp php-pecl-amqp php-amqp

RUN echo "extension=amqp.so" > /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini