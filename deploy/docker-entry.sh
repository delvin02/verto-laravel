#!/bin/bash

# Run Supervisor
service supervisor start

# Run PHP-fpm
service php8.0-fpm start

# Run Nginx
service nginx start

tail -f /dev/null