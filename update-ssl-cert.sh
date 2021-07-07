#!/bin/bash
# 上传 ssl 证书至服务器，并更新 nginx 的配置和重新加载

. ./conf.d/update-ssl-cert.conf

# 证书文件的本地完整路径
local_file=$local_cert_folder$cert_file_zip

if [ ! -f $local_file ]; then
  echo "文件不存在: $local_file" & exit 1
fi

# 上传至 home 目录
scp -P $port $local_file $username@$host:$remote_cert_folder
if [ ! $? -eq 0 ]; then
  echo "scp: 证书上传失败。"
  echo "1. 确保本地与远程服务器上均已安装 scp 工具"
  echo "2. 确保远程服务器已安装 openssh 客户端："
  echo "yum -y install openssh-clients (CentOS)"
  echo "apt-get install openssh-client (Debian/Ubantu)"
  exit 1
fi

# 拼接解压缩后的文件名称
if [[ $cert_file_zip =~ ^[0-9]+ ]]; then
  # 阿里云证书
  s1=$(echo $cert_file_zip | cut -d '_' -f 1)
  s2=$(echo $cert_file_zip | cut -d '_' -f 2)
  prefix=$s1'_'$s2
  pem=$prefix'.pem'
  key=$prefix'.key'
else
  # 腾讯云证书
  domain_name=$(echo $cert_file_zip | sed 's/.zip//')
  pem=$domain_name'.pem'
  key=$domain_name'.key'
fi


# 解压缩、替换 nginx 配置并重新加载配置
ssh -p $port $username@$host << EOF

# 解压缩证书文件
cd $remote_cert_folder
unzip -f $cert_file_zip $pem $key
rm -f ./$cert_file_zip

# 修改 nginx 配置文件
cd $remote_nginx_config_folder
sed -i.backup '
/ssl_certificate [[:print:]]/{
i\
ssl_certificate "$remote_cert_folder$pem";
d
}
/ssl_certificate_key [[:print:]]/{
i\
ssl_certificate_key "$remote_cert_folder$key";
d
}' $remote_nginx_config_file

# 测试并应用最新 nginx 配置
nginx -t -c $nginx_config
nginx -s reload

EOF


