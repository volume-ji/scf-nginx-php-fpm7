ARG ALPINE_VERSION=3.14
FROM alpine:${ALPINE_VERSION}
LABEL Description="Lightweight container with Nginx 1.20 & PHP 7.4 based on Alpine Linux 3.14."
# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN echo '@community http://dl-cdn.alpinelinux.org/alpine/v3.14/community' >> /etc/apk/repositories && \
  #apk update && \
  #apk upgrade && \ 
  apk add --no-cache \
  curl \
  nginx \
  php7@community \
  php7-ctype@community \
  php7-curl@community \
  php7-dom@community \
  php7-fileinfo@community \
  php7-fpm@community \
  php7-gd@community \
  php7-intl@community \
  php7-mbstring@community \
  php7-mysqli@community \
  php7-opcache@community \
  php7-openssl@community \
  php7-phar@community \
  php7-session@community \
  php7-tokenizer@community \
  php7-xml@community \
  php7-xmlreader@community \
  php7-xmlwriter@community \
  supervisor

# Configure nginx - http
COPY config/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY config/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
ENV PHP_INI_DIR /etc/php7
COPY config/fpm-pool.conf ${PHP_INI_DIR}/php-fpm.d/www.conf
COPY config/php.ini ${PHP_INI_DIR}/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
COPY --chown=nobody src/ /var/www/html/

# Expose the port nginx is reachable on, scf web function only allow 9000 port
EXPOSE 9000

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
# HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:9000/fpm-ping || exit 1
