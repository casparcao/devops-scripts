#!/bin/sh
#####
#该脚本用于关闭当前运行的服务，并重启新的的服务。
#该脚本要求jar包文件名必须与APP_FILE_REG的规则匹配，否则可能重启失败。
#####
WORK_DIR='/home/projects/anglepai/'
PID_FILE=$WORK_DIR'angelpie.pid'
APP_FILE_REG='ido85-anglepie-**.jar'
EXISTS_APP_FILE_NAME=$(basename $WORK_DIR$APP_FILE_REG)
TMP_DIR='/home/tmp/'
NEW_APP_FILE_NAME=$(basename $TMP_DIR$APP_FILE_REG)

if [ -e $PID_FILE ]; then
        PID=$(cat $PID_FILE)
        echo "关闭当前服务，服务PID=$PID"
        kill -9 $PID
        sleep 3
fi

if [ -e $TMP_DIR$NEW_APP_FILE_NAME ]; then
	echo "发现新服务文件$TMP_DIR$NEW_APP_FILE_NAME"
	rm -rf $WORK_DIR$EXISTS_APP_FILE_NAME
	cp $TMP_DIR$NEW_APP_FILE_NAME $WORK_DIR$NEW_APP_FILE_NAME
	sleep 3
fi

echo '重启服务开始'
mv nohup.out nohup.out.`date +%Y-%m-%d-%H-%M-%S-%N`
nohup /home/java/jdk8/bin/java -jar $WORK_DIR$NEW_APP_FILE_NAME > nohup.out 2>&1 &
echo $! > $PID_FILE
echo "重启服务完成，服务PID=$!"
