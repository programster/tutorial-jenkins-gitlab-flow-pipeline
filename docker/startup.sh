# Please do not manually call this file!
# This script is run by the docker container when it is "run"

# Create the .env file for site to load env vars from
/usr/bin/php /var/www/my-site/scripts/create-env-file.php "/var/www/my-site/.env"
chown root:www-data /.env
chmod 750 /.env


# Run the apache process in the background
#/usr/sbin/apache2 -D APACHE_PROCESS &
/usr/sbin/service apache2 start


# Start the cron service in the foreground
# We dont run apache in the FG, so that we can restart apache without container
# exiting.
cron -f
