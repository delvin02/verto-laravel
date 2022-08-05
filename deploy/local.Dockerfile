FROM ubuntu:22.04

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Australia/Perth

# Set the Timezone for Ubuntu
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update & Setup install
RUN apt update \
    && apt install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && add-apt-repository ppa:ondrej/nginx \
    && apt update \
    && apt -y upgrade \
    && apt install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python2 \
    && mkdir -p ~/.gnupg \
    && chmod 600 ~/.gnupg \
    && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
    && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C

# Install PHP 8
RUN apt install -y php8.0 php8.0-fpm php8.0-common \
    php8.0-sqlite3 php8.0-gd \
    php8.0-curl php8.0-memcached \
    php8.0-imap php8.0-mysql php8.0-mbstring \
    php8.0-xml php8.0-zip php8.0-bcmath php8.0-soap \
    php8.0-intl php8.0-readline php8.0-pcov \
    php8.0-msgpack php8.0-igbinary php8.0-ldap \
    php8.0-redis php8.0-swoole

# Setup PHP-FPM
RUN apt install -y nginx mysql-client

COPY ./nginx.conf /etc/nginx/sites-available/default
COPY ./php.ini /etc/php/8.0/fpm/php.ini

# Install Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Install Node LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt install -y nodejs

# Install Yarn
RUN npm install --global yarn

# Cleanup
RUN apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.0

EXPOSE 80

COPY ./docker-entry.sh /

RUN chmod 770 /docker-entry.sh

ENTRYPOINT [ "/docker-entry.sh" ]
# CMD tail -f /dev/null
