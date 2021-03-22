ARG CONFIG_NGINX_VERSION
ARG CONFIG_NGINX_DOCKER_IMAGE

FROM nginx:${CONFIG_NGINX_VERSION}-${CONFIG_NGINX_DOCKER_IMAGE}

# Make config args persistent
ARG CONFIG_LOCAL
ARG CONFIG_DESTINATION
ARG CONFIG_HOSTNAME
ENV CONFIG_LOCAL=${CONFIG_LOCAL}
ENV CONFIG_DESTINATION=${CONFIG_DESTINATION}
ENV CONFIG_HOSTNAME=${CONFIG_HOSTNAME}

# Copy NGINX conf file from provision folder to container
ADD ./provision/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./provision/nginx/default.conf /etc/nginx/conf.d/default.conf

# Replace default root directory with the config destination
RUN find ./ -type f -name \*.conf -exec sed -i "s@/var/www/html@$CONFIG_DESTINATION@" {} \;
RUN find ./ -type f -name \*.conf -exec sed -i "s@lemp-docker-vagrant-static-ip.com@$CONFIG_HOSTNAME@" {} \;

RUN mkdir -p ${CONFIG_DESTINATION}

RUN addgroup -g 998 www && adduser -G www -g www -s /bin/sh -D www

RUN chown -R www:www ${CONFIG_DESTINATION}
RUN chmod -R 0770 ${CONFIG_DESTINATION}

# Install self-signed SSL certificate
RUN apk add openssl \
        && openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=$CONFIG_HOSTNAME" -addext "subjectAltName=DNS:$CONFIG_HOSTNAME" -newkey rsa:2048 -keyout /etc/ssl/private/$CONFIG_HOSTNAME.key -out /etc/ssl/certs/$CONFIG_HOSTNAME.crt

