FROM debian:buster

WORKDIR /var/www/html

RUN apt-get update && apt-get -y install nginx mariadb-server wget vim openssl \
	php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring \
	&&  wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz \
	&& wget https://wordpress.org/latest.tar.gz \
	&& tar -xf phpMyAdmin-5.0.1-english.tar.gz \
	&& rm -rf phpMyAdmin-5.0.1-english.tar.gz \
	&& mv phpMyAdmin-5.0.1-english phpmyadmin \
	&& tar -xvzf latest.tar.gz && rm -rf latest.tar.gz \
	&& openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/localhost.pem -keyout /etc/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=cregazzo/CN=localhost"

COPY ./srcs/run.sh /var/www/html
COPY ./srcs/default /etc/nginx/sites-available
COPY ./srcs/config.inc.php phpmyadmin
COPY ./srcs/wp-config.php /var/www/html/

RUN chmod 777 /var/www/html/run.sh

EXPOSE 80 443

ENV AUTOINDEX on;

CMD "./run.sh"


