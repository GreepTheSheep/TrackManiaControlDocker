FROM php:8.2-alpine

RUN apk add --no-cache curl-dev libzip-dev libcurl libxml2-dev zlib-dev oniguruma-dev git xmlstarlet $PHPIZE_DEPS

# Install PHP dependencies
RUN docker-php-ext-install \
    mysqli \
    curl \
    xml \
    zip \
    mbstring

RUN pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3 && docker-php-ext-enable xmlrpc

RUN git clone https://git.virtit.fr/beu/TrackManiaControl.git /controller

RUN apk del git $PHPIZE_DEPS

WORKDIR /controller/

COPY entrypoint.sh /controller/

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/controller/entrypoint.sh" ]