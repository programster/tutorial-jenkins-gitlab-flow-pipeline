FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Fix timezone issue
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install php7.4 -y

# Install the relevant packages
# Need mysql-client for mysqldump command on backup endpoint.
RUN apt-get install -y vim cron apache2 libapache2-mod-php7.4 composer

RUN apt-get install libapache2-mod-php -y

RUN a2enmod php7.4

EXPOSE 80

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2


# set permissions on /var/www directory
RUN chmod 750 /var/www && chown root:www-data /var/www


# Copy the site source code to the container and set permissions
COPY --chown=root:www-data src /var/www/my-site
RUN chmod 750 -R /var/www/my-site


# Update our apache sites available with the config we created
ADD docker/apache-config.conf /etc/apache2/sites-enabled/000-default.conf


# Install composer packages and set permissions on those installed files
RUN cd /var/www/my-site && composer install \
  && chmod 750 -R /var/www/my-site/vendor \
  && chown root:www-data -R /var/www/my-site/vendor


# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
COPY --chown=root:root docker/startup.sh /root/startup.sh
CMD ["/bin/bash", "/root/startup.sh"]

