FROM php:8.1-fpm-alpine

# 使用 ustc 镜像加速
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&

RUN apk update && apk add --no-cache imagemagick imagemagick-dev \
    bash autoconf gcc g++ make nginx \
    libwebp-dev freetype-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev \
    && pecl install imagick \
    && apk del gcc g++ make autoconf \
    \
    # 需要sqlserver打开这个
    # && apk add --no-cache unixodbc-dev \
    # && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr && docker-php-ext-install pdo_odbc \
    # 需要sqlite打开这个
    # && apk add --no-cache sqlite-dev && docker-php-ext-install pdo_sqlite \
    # 需要postgresql打开这个
    # && apk add --no-cache postgresql-dev && docker-php-ext-install pdo_pgsql \
    \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-webp=/usr/include/webp --with-jpeg=/usr/include --with-freetype=/usr/include/ \
    && docker-php-ext-install gd

# # 需要sqlserver打开这个
# RUN apk add --no-cache unixodbc-dev \
#     && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr && docker-php-ext-install pdo_odbc

# # 需要sqlite打开这个
# RUN apk add --no-cache sqlite-dev && docker-php-ext-install pdo_sqlite

# # 需要postgresql打开这个
# RUN apk add --no-cache postgresql-dev && docker-php-ext-install pdo_pgsql


RUN { \
    echo 'post_max_size = 100M;';\
    echo 'upload_max_filesize = 100M;';\
    echo 'max_execution_time = 600S;';\
    echo "date.timezone = Asia/Shanghai";\
    } > $PHP_INI_DIR/conf.d/docker-php-upload.ini; \
    \
    { \
    echo 'opcache.enable=1'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.save_comments=1'; \
    echo 'opcache.revalidate_freq=1'; \
    } > $PHP_INI_DIR/conf.d/opcache-recommended.ini; \
    \
    echo 'apc.enable_cli=1' >> $PHP_INI_DIR/conf.d/docker-php-ext-apcu.ini; \
    \
    echo 'memory_limit=512M' > $PHP_INI_DIR/conf.d/memory-limit.ini; \
    \
    mkdir -p /var/www/data; \
    chown -R www-data:root /var/www; \
    chmod -R g=u /var/www

COPY ./lsky-pro/ /var/www/lsky/
COPY ./src/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./src/nginx/ /etc/nginx/
COPY ./src/entrypoint.sh /
WORKDIR /var/www/html
VOLUME /var/www/html
EXPOSE 80
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "nginx && php-fpm"]