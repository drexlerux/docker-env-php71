FROM ubuntu:16.04
MAINTAINER Carlos Porras <carlos.porras.0508@gmail.com>
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 16.04 LTS. Includes .htaccess support and popular PHP7.1 features, including composer and mail() function." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql drexlerux/lamp" \
	Version="1.0"

ARG DEBIAN_FRONTEND=noninteractive
ENV TERM xterm		
RUN apt-get update

RUN apt-get -y install wget
RUN apt-get -y install locales
RUN apt-get update

# Initialize environment
CMD ["/sbin/my_init"]
ENV DEBIAN_FRONTEND noninteractive
# Set the locale
RUN \
    locale-gen en_US.UTF-8 && \
    localedef en_US.UTF-8 -i en_US -fUTF-8 && \
    dpkg-reconfigure locales && \
    echo "LANG=en_US.UTF-8" >> /etc/default/locale && \
    echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale && \
    export LANG=en_US.UTF-8 && \
    export LANGUAGE=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    LANG=en_US.UTF-8 && \
    LANGUAGE=en_US.UTF-8 && \
    LC_ALL=en_US.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN LC_ALL=C.UTF-8 apt-add-repository -y -u ppa:ondrej/php
RUN apt-get update
RUN apt-get upgrade -y

COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y imagemagick graphicsmagick

RUN apt-get install -y \
	php7.1 \
	php7.1-bz2 \
	php7.1-cgi \
	php7.1-cli \
	php7.1-common \
	php7.1-curl \
	php7.1-dev \
	php7.1-enchant \
	php7.1-fpm \
	php7.1-gd \
	php7.1-gmp \
	php7.1-imap \
	php7.1-interbase \
	php7.1-intl \
	php7.1-json \
	php7.1-ldap \
	php7.1-mcrypt \
	php7.1-mysql \
	php7.1-odbc \
	php7.1-opcache \
	php7.1-pgsql \
	php7.1-phpdbg \
	php7.1-pspell \
	php7.1-readline \
	php7.1-recode \
	php7.1-imagick \
	php7.1-snmp \
	php7.1-sqlite3 \
	php7.1-sybase \
	php7.1-tidy \
	php7.1-xmlrpc \
	php7.1-xsl \
	php7.1-mbstring \ 
	php7.1-zip  
	
RUN apt-get install apache2 libapache2-mod-php7.1 -y

RUN apt-get install postfix -y
RUN apt-get install git composer nano vim curl ftp -y

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY index.php /var/www/html/
COPY run-script.sh /usr/sbin/

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-script.sh
RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql

EXPOSE 80
EXPOSE 8080
EXPOSE 3000
EXPOSE 8000

CMD ["/usr/sbin/run-script.sh"]