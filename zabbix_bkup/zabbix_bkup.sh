#!/bin/sh

# バックアップ対象Zabbix情報指定
ZABBIX_DB_USER="CHANGE_HERE"
ZABBIX_DB_PASS="CHANGE_HERE"
ZABBIX_DB_NAME="CHANGE_HERE"

# scp情報指定
ScpKey="CHANGE_HERE"
ScpUser="CHANGE_HERE"

# バックアップデータ転送先サーバ情報指定
BK="CHANGE_HERE"
BK_PATH="/data/zabbix/"

# バックアップデータ保存先指定
BASE_PATH="/etc/zabbix/backup/"

# バックアップデータのファイル名生成
time=$(date "+%Y%m%d_%H%M%S")
BACKUP_FILE_NAME="zabbix_backup_${time}.sql.gz"

# バックアップ処理(mysqldump)
mysqldump -u ${ZABBIX_DB_USER} -p${ZABBIX_DB_PASS} \
--single-transaction --hex-blob ${ZABBIX_DB_NAME} \
--ignore-table=${ZABBIX_DB_NAME}.history \
--ignore-table=${ZABBIX_DB_NAME}.history_uint \
--ignore-table=${ZABBIX_DB_NAME}.trends_uint \
--ignore-table=${ZABBIX_DB_NAME}.trends \
--ignore-table=${ZABBIX_DB_NAME}.history_str \
--ignore-table=${ZABBIX_DB_NAME}.history_text \
--ignore-table=${ZABBIX_DB_NAME}.history_log \
--ignore-table=${ZABBIX_DB_NAME}.alerts \
--ignore-table=${ZABBIX_DB_NAME}.auditlog \
--ignore-table=${ZABBIX_DB_NAME}.auditlog_details \
--ignore-table=${ZABBIX_DB_NAME}.events \
--ignore-table=${ZABBIX_DB_NAME}.acknowledges \
--ignore-table=${ZABBIX_DB_NAME}.escalations \
--ignore-table=${ZABBIX_DB_NAME}.problem \
--ignore-table=${ZABBIX_DB_NAME}.problem_tag \
--ignore-table=${ZABBIX_DB_NAME}.event_recovery \
--ignore-table=${ZABBIX_DB_NAME}.task_acknowledge \
--ignore-table=${ZABBIX_DB_NAME}.task_close_problem \
--ignore-table=${ZABBIX_DB_NAME}.task_remote_command \
--ignore-table=${ZABBIX_DB_NAME}.task_remote_command_result \
--ignore-table=${ZABBIX_DB_NAME}.event_suppress \
--ignore-table=${ZABBIX_DB_NAME}.task_check_now \
--ignore-table=${ZABBIX_DB_NAME}.task \
| gzip > ${BASE_PATH}${BACKUP_FILE_NAME}

# mysqldumpが正常に行われたらバックアップデータ転送
if [ ${PIPESTATUS[0]} = 0 ]; then
   scp -i $ScpKey $BASE_PATH$BACKUP_FILE_NAME $ScpUser@$BK:$BK_PATH
fi

# バックアップ実行サーバではデータをためないように1日以上古いバックアップデータ削除
find $BASE_PATH -mtime +1 -exec rm -f {} \;

exit
