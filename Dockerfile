FROM php:8.2-alpine

RUN apk add --no-cache curl curl-dev pkgconf libcurl libxml2-dev php-curl git xmlstarlet

# Install PHP dependencies
RUN docker-php-ext-install \
    mysqli \
    curl \
    xml \
    simplexml \
    zlib \
    zip \
    mbstring

RUN git clone https://git.virtit.fr/beu/TrackManiaControl.git /controller

WORKDIR /controller/

COPY entrypoint.sh /controller/

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/controller/entrypoint.sh" ]