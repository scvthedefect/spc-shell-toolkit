#!/bin/bash
## create new user on remote server and no-password login set-up.
## 在服务器中创建用户，并设置 ssh 免密登录。

if [[ $LANG == *"zh_CN"* ]]; then
  . ./i18n/adduser_zh.conf
else
  . ./i18n/adduser_en.conf
fi

# config file
. ./conf.d/adduser.conf

if [ -z "$server" ]; then
  read -p $hint_host_read server
fi
if [ -z "$server" ]; then
  echo "$hint_host_err" & exit 1
fi

if [ -z "$admin" ]; then
  read -p "$hint_admin_read" admin
fi
if [ -z "$admin" ]; then
  echo "$hint_admin_err" & exit 1
fi

public_key=$(cat $key_file)

echo "######################################################################################"
echo "Login as admin[$admin] and then create the new user [$username] at server [$server]."
echo "######################################################################################"

config_file=".ssh/authorized_keys"
ssh -p $port $admin@$server << EOF
useradd $username
(echo $password & sleep 1 & echo $password & sleep 1) | passwd $username

su $username
echo "" | ssh-keygen -t rsa
sleep 1
echo ""
echo -n "$hint_remote_whoami" && whoami

cd ~
echo $public_key >> $config_file
chmod 600 $config_file
echo "Done."
exit
EOF

echo "$hint_on_success"
echo "ssh -p $port $username@$server"

# notes:
# - use below command to remove the user and related home directory if necessary.
# userdel -r $username
# 
# - another way to upload your public key to the specified user:
# ssh-copy-id -i $key_file $username@$server
