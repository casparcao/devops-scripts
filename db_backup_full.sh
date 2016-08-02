#!/bin/sh
/usr/local/mysql/bin/mysqldump -uangelpie -ptianshipai@85123 -h123.57.21.112 -R angelpie > /home/backup/db/dump/angelpie_bk_`date +%Y-%m-%d-%H-%M-%S-%N`.sql
