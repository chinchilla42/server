#add instruction to keep container running
echo "daemon off;" >> /etc/nginx/nginx.conf

#disable autoindex if AUTOINDEX env var is set to off
if [ $AUTOINDEX = "off" ]
then
    sed -i "s/autoindex on/autoindex off/g" /etc/nginx/sites-available/default
fi

service php7.3-fpm start
service mysql start

# Configure a wordpress database
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

service nginx start
