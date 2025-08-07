# `Server`联网

## 教程

### 可上网主机代理

#### 测试连通性

首先测试服务器是否可以`ping`通主机(即在同一网段内)：

若可以`ping`通，则记录主机的 $ip$:`ip地址` 以及 $port$:`梯子的代理端口`

要将 HTTP 和 HTTPS 代理配置写入文件，并使其长期生效，通常有几种方法，取决于你使用的操作系统和环境。以下是几种常见的方法：

#### 设置环境变量

##### 1. Linux/MacOS: 设置环境变量

你可以将代理设置写入用户的 shell 配置文件（如 `.bashrc`、`.bash_profile` 或 `.zshrc` 等）中。这样，每次打开新的终端时都会自动生效。

1. 打开你的 shell 配置文件，通常是 `~/.bashrc` 或 `~/.zshrc`：

   ```bash
   nano ~/.bashrc  # 或者 nano ~/.zshrc
   ```

2. 在文件末尾添加以下内容，设置 HTTP 和 HTTPS 代理：

   ```bash
   export http_proxy="http://ip:port"
   export https_proxy="https://ip:port"
   export HTTP_PROXY="http://ip:port"
   export HTTPS_PROXY="https://ip:port"
   ```

   - `ip` 替换为你的代理服务器地址。
   - `port` 替换为你的代理端口。

3. 保存并关闭文件后，执行以下命令使设置生效：

   ```bash
   source ~/.bashrc  # 或者 source ~/.zshrc
   ```

##### 2. Windows: 设置系统环境变量

在 Windows 上，你可以通过系统的环境变量来设置代理，这样所有应用程序都会使用这些代理设置。

1. 右键点击“此电脑”并选择“属性”。
2. 在左侧点击“高级系统设置”。
3. 在弹出的窗口中选择“环境变量”。
4. 在“系统变量”部分点击“新建”，然后添加以下变量：
   - 变量名：`http_proxy`，变量值：`http://ip:port`
   - 变量名：`https_proxy`，变量值：`https://ip:port`
5. 点击“确定”保存设置。

##### 3. 配置软件（如 APT, YUM, Git 等）使用代理

许多程序允许你在其配置文件中直接设置代理。以下是一些常见的配置：

###### APT（Debian/Ubuntu 系统）

1. 创建或编辑 `/etc/apt/apt.conf.d/95proxies` 文件：

   ```bash
   sudo nano /etc/apt/apt.conf.d/95proxies
   ```

2. 添加以下内容：

   ```bash
   Acquire::http::Proxy "http://ip:port";
   Acquire::https::Proxy "https://ip:port";
   ```

3. 保存并关闭文件。

###### YUM（CentOS/RHEL 系统）

1. 编辑 `/etc/yum.conf` 文件：

   ```bash
   sudo nano /etc/yum.conf
   ```

2. 添加以下内容：

   ```bash
   proxy=http://your_proxy_address:port
   ```

3. 保存并关闭文件。

###### Git

如果你在 Git 中需要使用代理，可以通过命令设置：

```bash
git config --global http.proxy http://your_proxy_address:port
git config --global https.proxy https://your_proxy_address:port
```

##### 4. 使代理在 Docker 中生效

如果你正在使用 Docker，可以通过在 Docker 配置文件中设置代理。

1. 创建或编辑 `/etc/systemd/system/docker.service.d/http-proxy.conf` 文件：

   ```bash
   sudo mkdir -p /etc/systemd/system/docker.service.d
   sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
   ```

2. 添加以下内容：

   ```bash
   [Service]
   Environment="HTTP_PROXY=http://your_proxy_address:port"
   Environment="HTTPS_PROXY=https://your_proxy_address:port"
   ```

3. 保存文件后，重新加载 Docker 配置：

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart docker
   ```

通过这些方法，你可以确保代理配置长期生效，并且对系统中多个工具和应用程序产生影响。
