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

**Pending:**

- [ ] 支持设置用户组
- [ ] 免密登录设置改为可选

