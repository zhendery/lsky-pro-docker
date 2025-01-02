#!/bin/bash
set -eu

chown -R www-data /var/www/html
chgrp -R www-data /var/www/html
chmod -R 755 /var/www/html/

exec "$@"
