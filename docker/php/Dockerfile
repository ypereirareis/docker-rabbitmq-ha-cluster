FROM zolweb/php7:2.2-alpine

ENV RABBITMQ_C_VER 0.8.0

RUN set -xe \
  && apk add --update --no-cache \
    wget \
    cmake \
    openssl-dev \
  && rm -rf /var/cache/apk/* \

  # RabbitMQ C client
  && wget -qO- https://github.com/alanxz/rabbitmq-c/releases/download/v${RABBITMQ_C_VER}/rabbitmq-c-${RABBITMQ_C_VER}.tar.gz | tar xz -C /tmp/ \
  && cd /tmp/rabbitmq-c-${RABBITMQ_C_VER} \
  && mkdir -p build \
  && cd build \
  && cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_C_FLAGS="$CFLAGS" \
  && cmake --build . --target install \
  && apk del \
    wget \
    cmake \
    openssl-dev

# Install tools...
RUN set -x \
  && docker-php-ext-install \
    bcmath \
    pcntl \
  && pecl install \
    amqp \
  && docker-php-ext-enable amqp
