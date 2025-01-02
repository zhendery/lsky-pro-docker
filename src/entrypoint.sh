#!/bin/bash
set -eu

# 如果是初次安装，则把项目移动到html下进行持久化，主要是.env和installed.lock，以及本地存储中已上传的图片
if [ -e '/var/www/lsky' ]; then
    cp -rf /var/www/lsky/* /var/www/html/
    rm -rf /var/www/lsky
fi

chown -R www-data /var/www/html
chgrp -R www-data /var/www/html
chmod -R 755 /var/www/html/

exec "$@"
