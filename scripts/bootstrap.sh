#!/bin/bash

LOCAL_BACKUP_DIR="./backup"
#TODO: Backup all logs files
#TODO: Check if mysql cred exist

backup_log_file()
{
    LOG_PATH="$1"
    LOG_FILENAME=`basename ${LOG_PATH}`
    LOG_FILENAME_NO_EXT="${LOG_FILENAME%.*}"
    LOG_EXT="${LOG_FILENAME##*.}"
    if [ -f ${LOG_PATH} ] ; then
        if [ `ls ${LOCAL_BACKUP_DIR}/${LOG_FILENAME_NO_EXT}/${LOG_FILENAME_NO_EXT}.$(date '+%Y-%m-%d')*.${LOG_EXT}.gz 2> /dev/null | wc -l` == '0' ] ; then
            LOG_DESTINATION=${LOCAL_BACKUP_DIR}/${LOG_FILENAME_NO_EXT}/${LOG_FILENAME_NO_EXT}.`date '+%Y-%m-%d_%H-%M-%S'`.${LOG_EXT}.gz
            LOG_FILES_STR=`ls ${LOG_PATH%.*}.{$LOG_EXT.*,$LOG_EXT} 2> /dev/null | awk '{print "\""$0"\""}' | tr '\n' ', ' | sed 's/,$/\n/'`
            LOG_FILES=`ls ${LOG_PATH%.*}.{$LOG_EXT.*,$LOG_EXT} 2> /dev/null`
            echo "[$(date '+%Y-%m-%d %T')] [Booststrap]  +-> Backuping ${LOG_FILES_STR} to \"${LOG_DESTINATION}\""
            mkdir -p ${LOCAL_BACKUP_DIR}/${LOG_FILENAME_NO_EXT}/
            if ($(gzip -9 -c ${LOG_FILES} > ${LOG_DESTINATION})) ; then
                echo "[$(date '+%Y-%m-%d %T')] [Booststrap]  +-> Clearing logs ${LOG_FILES_STR}"
                rm -f ${LOG_PATH}.*
                > ${LOG_PATH}
            fi
        fi
    fi
}

while true
do
    # Backup logs
    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Backuping logs"
        backup_log_file server_log.txt
        backup_log_file svlog.txt
        backup_log_file mysql_log.txt
        backup_log_file scriptfiles/mysql_error.txt
    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Logs successfully backuped"

    # Backup database
    if [ $(date '+%d') == '01' ] || [ $(date '+%d') == '15' ] ; then
        mysql_database=$(  jq -r ".mysql.database" server.conf.json)
        if [ `ls ${LOCAL_BACKUP_DIR}/database/${mysql_database}.$(date '+%Y-%m-%d')*.sql.gz 2> /dev/null | wc -l` == '0' ] ; then
            echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Backuping database"
            mkdir -p ${LOCAL_BACKUP_DIR}/database/
            mysql_hostname=$(  jq -r ".mysql.hostname" server.conf.json)
            mysql_username=$(  jq -r ".mysql.username" server.conf.json)
            mysql_password=$(  jq -r ".mysql.password" server.conf.json)
            mysql_port=$(  jq -r ".mysql.port" server.conf.json)
            MYSQL_BACKUP_FILE=${LOCAL_BACKUP_DIR}/database/${mysql_database}.`date '+%Y-%m-%d_%H-%M-%S'`.sql
            if ($( mysqldump --no-tablespaces --host=${mysql_hostname} --port=${mysql_port} --user=${mysql_username} --password=${mysql_password}  ${mysql_database} > ${MYSQL_BACKUP_FILE} )) ; then
                if ($( gzip -9 ${MYSQL_BACKUP_FILE} )) ; then
                    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Database successfully backuped to '${MYSQL_BACKUP_FILE}.gz'"
                else
                    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Failed compressing database from '${MYSQL_BACKUP_FILE}' to \"${MYSQL_BACKUP_FILE}.gz\""
                fi
            else
                echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Failed dumping  database ${mysql_database} to \"${MYSQL_BACKUP_FILE}\""
            fi
            unset mysql_port
            unset mysql_password
            unset mysql_username
            unset mysql_hostname
            unset MYSQL_BACKUP_FILE
        fi
        unset mysql_database
    fi
    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] Starting ./samp03svr"
    ./samp03svr
    echo "[$(date '+%Y-%m-%d %T')] [Booststrap] ./samp03svr was stopped"

done
