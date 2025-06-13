#!/bin/bash

gamemode=$(./scripts/serverinfo.py | grep gamemode | cut -f2 -d=)
version=$(echo ${gamemode}|cut -f2,3 -d-)

mysql_database=$( jq -r ".mysql.database" server.conf.json )
mysql_hostname=$( jq -r ".mysql.hostname" server.conf.json )
mysql_username=$( jq -r ".mysql.username" server.conf.json )
mysql_password=$( jq -r ".mysql.password" server.conf.json )
mysql_port=$( jq -r ".mysql.port"     server.conf.json )

echo "[$(date '+%Y-%m-%d %T')] [Backup]  +-> Exporting database \"${mysql_database}\""
TABLES_TO_EXPORT=$(echo "SHOW TABLES WHERE tables_in_${mysql_database} NOT LIKE 'log\_%';" | mysql -h $mysql_hostname -P $mysql_port -u $mysql_username -p$mysql_password -Bs --database=$mysql_database )
MYSQL_BACKUP_FILE=${mysql_database}.nologs.`date '+%Y-%m-%d_%H-%M-%S'`.sql
mysqldump --routines --no-tablespaces --host=${mysql_hostname} --port=${mysql_port} --user=${mysql_username} --password=${mysql_password}  ${mysql_database} --no-data > ${MYSQL_BACKUP_FILE}
mysqldump --no-tablespaces --host=${mysql_hostname} --port=${mysql_port} --user=${mysql_username} --password=${mysql_password}  ${mysql_database} --no-create-info ${TABLES_TO_EXPORT} >> ${MYSQL_BACKUP_FILE}
unset mysql_port
unset mysql_password
unset mysql_username
unset mysql_hostname
echo "[$(date '+%Y-%m-%d %T')] [Backup]  +-> Compressing database \"${mysql_database}\""
unset mysql_database
gzip -9 ${MYSQL_BACKUP_FILE}
echo "[$(date '+%Y-%m-%d %T')] [Backup]  +-> Compressing ${PWD##*/}"
SERVER_BACKUP_FILENAME="../${PWD##*/}.`date '+%Y-%m-%d_%H-%M-%S'`.${version}.tar"
tar -czf ${SERVER_BACKUP_FILENAME} --exclude=./samp03svr.pid --exclude=./samp03svr.log --exclude=./nohup.out  --exclude=crash.log --exclude=./backup --exclude=./server_log.txt* --exclude=./mysql_log.txt* --exclude=./svlog.txt* --exclude=./scriptfiles/mysql_error.txt* .
rm ${MYSQL_BACKUP_FILE}.gz
echo "[$(date '+%Y-%m-%d %T')] [Backup]  +-> Successfully backup to '${SERVER_BACKUP_FILENAME}'"
