FROM php:8.2-alpine

# Install PHP dependencies
RUN apk add --no-cache \
    php-mysqli \
    php-curl \
    php-xml \
    php-simplexml \
    php-zlib \
    php-zip \
    php-mbstring

RUN apk add --no-cache git xmlstarlet

RUN git clone https://git.virtit.fr/beu/TrackManiaControl.git /controller

WORKDIR /controller/

COPY entrypoint.sh /controller/

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/controller/entrypoint.sh" ]