#! /bin/bash

####
# A "very!" basic bash scripts to dump all of the databases that the
# defined user has access to. Can be easily run from a cron job for
# daily backups etc.
####
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="/backup/$TIMESTAMP"
MYSQL_USER="backup"
MYSQL_PASSWORD="password"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
 
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev
"(Database|information_schema|performance_schema)"`
 
for db in $databases; do
	$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >
"$BACKUP_DIR/mysql/$db.gz"
done
