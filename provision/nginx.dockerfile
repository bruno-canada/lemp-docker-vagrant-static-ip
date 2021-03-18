ARG CONFIG_NGINX_VERSION
ARG CONFIG_NGINX_DOCKER_IMAGE

FROM nginx:${CONFIG_NGINX_VERSION}-${CONFIG_NGINX_DOCKER_IMAGE}

# Make config args persistent
ARG CONFIG_LOCAL
ARG CONFIG_DESTINATION
ENV CONFIG_LOCAL=${CONFIG_LOCAL}
ENV CONFIG_DESTINATION=${CONFIG_DESTINATION}

# Copy NGINX conf file from provision folder to container
ADD ./provision/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./provision/nginx/default.conf /etc/nginx/conf.d/default.conf

# Replace default root directory with the config destination
RUN find ./ -type f -name \*.conf -exec sed -i "s@/var/www/html@$CONFIG_DESTINATION@" {} \;

RUN mkdir -p ${CONFIG_DESTINATION}

RUN addgroup -g 998 www && adduser -G www -g www -s /bin/sh -D www

RUN chown -R www:www ${CONFIG_DESTINATION}
RUN chmod -R 0770 ${CONFIG_DESTINATION}