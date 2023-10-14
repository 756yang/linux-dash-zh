#!/bin/bash

git clone --depth 1 https://github.com/756yang/linux-dash-zh.git
cd linux-dash-zh/server
npm install --production

if [[ "$(cat /proc/version)" =~ Debian ]]; then
    sudo apt install coreutils sed grep gawk procps net-tools util-linux lsb-release hostname iputils-ping login cron lm-sensors dnsutils ncat
fi

echo "please run the command to start linux-dash-zh:"
echo "sudo LINUX_DASH_SERVER_PORT=8080 node linux-dash-zh/server/index.js"
