#!/bin/bash
set -eu

# 如果是初次安装，则把项目移动到html下进行持久化，主要是.env和installed.lock，以及本地存储中已上传的图片
if [ -e '/var/www/lsky' ]; then
    cp -af /var/www/lsky/* /var/www/html/
    cp -af /var/www/lsky/.env.example /var/www/html/.env.example # 隐藏文件需要单独复制
    rm -rf /var/www/lsky
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/

# 启动两个进程
nginx -g 'daemon off;' &
NGINX_PID=$!

php-fpm &
PHP_PID=$!

# 收到信号时优雅关闭两个
term() {
    kill -TERM "$NGINX_PID" "$PHP_PID" 2>/dev/null || true
    wait
    exit 0
}
trap term TERM INT

# 任一进程退出，整体退出
wait -n
term