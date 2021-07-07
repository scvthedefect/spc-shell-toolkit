# spc-shell-toolkit

### 使用方式

一、使用 `git clone` 命令下载本项目。

二、进入 `conf.d` 文件夹，将相应 example 配置文件复制为不带 `.example` 后缀的新文件，并在新文件中进行所需的配置。

例如，要使用 `adduser.sh`，则将 `conf.d` 目录中的 `/adduser.conf.example` 复制并命名为 `adduser.conf`，并修改 `adduser.conf` 相应的配置。

三、如果脚本没有执行权限，还要使用命令 `sudo chmod u+x script.sh` 使其可执行。

### 环境说明

- 本地环境：MacOS 11.3
- 服务器系统：CentOS 7.x

### 脚本：adduser.sh

用于完成在远程服务器中创建账号、设置初始密码，并上传特定公钥的一系列操作，使该新账号可以直接完成 ssh 免密登录。

注意，你在服务器上的账号**必须拥有管理员权限**，且该管理员账号已完成 ssh 免密登录设置 (如使用命令 `ssh-copy-id adminuser@server` 上传本机 ssh 公钥)。

配置文件说明：

```
# 远程服务器的ip地址
server=255.255.255.255

# 远程服务器的 ssh 登录端口
port=22

# 你的管理员账号
admin=root

# 新账号用户名
username=jerry

# 新账号初始密码
password=init-pass

# 新账号的公钥文件
key_file=~/.ssh/id_rsa.pub
```

**后续更新：**

- [ ] 支持设置用户组
- [ ] 免密登录设置改为可选

### 脚本：update-ssl-cert.sh

当你需要使用在阿里云或腾讯云平台申请的 SSL 证书时，且证书即将到期需要更新时，可使用该脚本进行自动更新。

脚本内容：

- scp 复制本地证书 (压缩文件) 到远程服务器
- 推测证书文件的名称 (解压缩后)
- 登录远程服务器，修改 nginx 配置文件的 `ssl_certificate` 和 `ssl_certificate_key` 两个配置
- 重新加载 nginx 配置文件

使用方式：

1. 从阿里云或腾讯云上下载已签发的 SSL 证书压缩包 (*.zip 文件)
2. 在当前项目的 `conf.d` 文件夹中复制配置文件 (`update-ssl-cert.conf.example` 复制为不带 .example 后缀的新文件)
3. 编辑新文件 `update-ssl-cert.conf` 中的配置
4. 运行脚本 `update-ssl-cert.sh` (可能需要赋予运行权限: `chmod u+x update-ssl-cert.sh`)

一些注意事项：

- 运行环境：MacOS 11.3 (本地) / CentOS 7.x (远程服务器)
- 仅支持从阿里云、腾讯云下载的压缩文件 (文件名解析有别)
- 远程服务器 web server 仅支持 nginx
- 强烈建议初次运行前，手动备份远程服务器的 nginx 配置
- **非常重要：被修改的 nginx 配置文件，应该只对应一个域名。如果文件里存在多个 `ssl_certificate` 和 `ssl_certificate_key` 配置项，则均会被修改！**

配置说明：

```
# 远程服务器 ip 地址
host=255.255.255.255

# 服务器 ssh 登录端口
port=22

# 服务器管理员账号
username=root

# 本地存放从阿里云或腾讯云下载的证书压缩包的目录
local_cert_folder="~/Downloads/ssl_certs/"

# 证书文件压缩包 (该格式为阿里云下载的文件)
cert_file_zip="1234567_www.foobar.com_nginx.zip"

# 远程服务器存放证书的目录
remote_cert_folder="/usr/local/ssl_certs/"

# 服务器存放 nginx 配置的目录 (默认安装的 nginx 应该不用改)
remote_nginx_config_folder="/etc/nginx/conf.d/"

# 服务器 - 待更新证书的域名配置文件 (一般被 include 在 ../nginx.conf 中)
remote_nginx_config_file="www.foobar.com.conf"

# 服务器的 nginx 配置文件 (总配置文件，一般无需修改)
nginx_config="/etc/nginx/nginx.conf"
```

**后续更新：**

- [ ] 支持 profile 的配置方式




