#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
if [ $GID != $(echo `id -g deepin`) ]; then
    groupmod -o -g $GID deepin
fi
if [ $UID != $(echo `id -u deepin`) ]; then
    usermod -o -u $UID deepin
fi
chown -R deepin:deepin /WeChatFiles
chown -R deepin:deepin /home/deepin

su deepin <<EOF
    echo "启动 $APP"
    "/opt/apps/com.qq.weixin.deepin/files/run.sh"
   sleep 300
EOF

while test -n "`pidof WeChat.exe`"
do
    sleep 10
done
echo "退出"


