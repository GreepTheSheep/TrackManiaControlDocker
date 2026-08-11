FROM php:8.2-alpine

ARG VERSION \
    BUILD_DATE \
    REVISION

LABEL org.opencontainers.image.title="TrackManiaControl" \
      org.opencontainers.image.description="Fork of Maniacontrol adapted for PHP 8.2 and later and TrackMania 2020" \
      org.opencontainers.image.authors="Greep <greep@greep.fr>" \
      org.opencontainers.image.vendor="Greep" \
      org.opencontainers.image.licenses="Unlicence" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.revision=${REVISION}

RUN apk add --no-cache curl-dev libzip-dev libcurl libxml2-dev zlib-dev oniguruma-dev git xmlstarlet $PHPIZE_DEPS

# Install PHP dependencies
RUN docker-php-ext-install \
    mysqli \
    curl \
    xml \
    zip \
    mbstring

RUN pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3 && docker-php-ext-enable xmlrpc

RUN true \
    && set -eux \
    && addgroup -g 9999 maniacontrol \
    && adduser -u 9999 -Hh /controller -G maniacontrol -s /sbin/nologin -D maniacontrol \
    && install -d -o maniacontrol -g maniacontrol -m 775 /controller \
    && true

USER maniacontrol
RUN git clone https://git.virtit.fr/beu/TrackManiaControl.git /controller
USER root

RUN apk del git $PHPIZE_DEPS

WORKDIR /controller

COPY --chown=0755 ./entrypoint.sh /controller/

RUN true \
    && set -eux \
    && rm -rf .git README.md \
    && chown maniacontrol:maniacontrol -Rf /controller \
    && true

USER maniacontrol

ENTRYPOINT [ "/controller/entrypoint.sh" ]
CMD [ "php", "./ManiaControl.php" ]