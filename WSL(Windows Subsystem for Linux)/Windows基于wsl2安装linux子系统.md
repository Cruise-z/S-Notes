# Windows基于wsl2安装linux子系统

**配置总参考：**https://learn.microsoft.com/en-us/windows/wsl/install

## 安装步骤：

### 初始安装：

#### 自动安装

1. 打开windows powershell

2. 执行：

   ```powershell
   wsl --install
   ```

#### 手动安装

1. 启用适用于 Linux 的 Windows 子系统

   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   ```

2. 启用虚拟机功能

   ```powershell
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

3. 下载 Linux 内核更新包

   - 下载最新包

     ```powershell
     https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
     ```

   - 运行上一步中下载的更新包。（双击以运行 - 系统将提示你提供提升的权限，选择“是”以批准此安装。）

4. 将 WSL 2 设置为默认版本

   ```powershell
   wsl --set-default-version 2
   ```

5. 安装所选的 Linux 分发

   - 打开 Microsoft Store，并选择你偏好的 Linux 分发版。
   - 在分发版的页面中，选择“获取”
   - 首次启动新安装的 Linux 分发版时，将打开一个控制台窗口，系统会要求你等待一分钟或两分钟，以便文件解压缩并存储到电脑上。 未来的所有启动时间应不到一秒。
   - 然后，需要为新的 Linux 分发版创建用户帐户和密码



#### ==**报错问题：**==

- **安装时==报错==**：`WslRegisterDistribution failed with error: 0x800701bc`

   - 参考文献：https://blog.csdn.net/m0_46411851/article/details/130029478?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-130029478-blog-129788056.235%5Ev40%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-130029478-blog-129788056.235%5Ev40%5Epc_relevant_anti_vip&utm_relevant_index=1

   - 下载最新的wsl安装包，直接安装即可

     [安装包](./Windows%E5%9F%BA%E4%BA%8Ewsl2%E5%AE%89%E8%A3%85linux%E5%AD%90%E7%B3%BB%E7%BB%9F.assets/wsl_update_x64.msi)
     
     ![image-20240108172342717](./Windows%E5%9F%BA%E4%BA%8Ewsl2%E5%AE%89%E8%A3%85linux%E5%AD%90%E7%B3%BB%E7%BB%9F.assets/image-20240108172342717.png)

- **安装时==报错==**：`安装其中一个文件系统时出现错误。有关详细信息，请运行'dmesg'`

   - 参考文献：https://blog.csdn.net/m0_46149348/article/details/122541217

   - 在powershell中运行如下命令：

     ```powershell
     wsl --update
     wsl --shutdown
     ```

   - 重启wsl即可

- **安装时==报错==**：`wsl: 检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理。`

   - 参考文献：

     - https://github.com/microsoft/WSL/issues/10753
     - https://blog.csdn.net/weixin_50925658/article/details/135111897?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-135111897-blog-134458330.235%5Ev40%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-135111897-blog-134458330.235%5Ev40%5Epc_relevant_anti_vip&utm_relevant_index=5
     - https://blog.csdn.net/weixin_62355896/article/details/134458330?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-134458330-blog-135048661.235%5Ev40%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-134458330-blog-135048661.235%5Ev40%5Epc_relevant_anti_vip&utm_relevant_index=1

   - 出现这样的问题会导致linux子系统的internet配置信息和宿主机不同步，无法使用本机已经配置好的代理，不方便

     因此**采用镜像的方法将宿主机windows的internet配置镜像到linux的子系统中**

   - 解决办法：

     - 在Windows中的`C:\Users\<your_username>`目录下创建一个`.wslconfig`文件

       ![image-20240108190337443](./Windows%E5%9F%BA%E4%BA%8Ewsl2%E5%AE%89%E8%A3%85linux%E5%AD%90%E7%B3%BB%E7%BB%9F.assets/image-20240108190337443.png)

     - 在文件中写入如下内容：

       ```powershell
       [experimental]
       autoMemoryReclaim=gradual    # gradual  | dropcache | disabled
       networkingMode=mirrored
       dnsTunneling=true
       firewall=true
       autoProxy=true
       ```

     - 在powershell中运行如下命令：

       ```powershell
       wsl --shutdown
       wsl
       ```

   - 无报错，安装成功



## 迁移系统镜像：

### 正常迁移

- 停止WSL子系统：

  ```sh
  wsl --shutdown
  ```

- 查看wsl状态：

  ```sh
  wsl -l -v
  ```

  ```sh
  C:\Users\xxx\Desktop>wsl -l -v
    NAME      STATE           VERSION
  * Ubuntu    Stopped         2
  ```

  查看wsl下的Linux是否为关闭状态，当STATE为Stopped才能进行下一步

- 导出系统镜像：

  ```sh
  wsl --export Ubuntu D:\UbuntuWSL\ubuntu.tar
  ```

- 注销原有的linux系统：

  ```sh
  wsl --unregister Ubuntu
  ```

- 导入系统：

  ```sh
  wsl --import <导入的Linux名称> <导入盘的路径> <ubuntu.tar的路径> --version 2 (代表wsl2)
  ```

  ```sh
  wsl --import Ubuntu D:\UbuntuWSL\ D:\UbuntuWSL\ubuntu.tar --version 2
  ```

- 修改默认用户：

  打开wsl ubuntu之后，默认以root身份登录

  ```sh
  ubuntu.exe config --default-user <user name>
  ```

  - 在导入任意盘linux系统时，我起名Ubuntu，所以这里是ubuntu.exe；

    如果你起的名字是Ubuntu-20.04，那这里就是ubuntu2004.exe；

    如果你起的名字是ubuntu-18.04，那这里就是ubuntu1804.exe

  - <user name>是原有wsl ubuntu的用户名称

### 迁移.vhdx文件

- 按照上面的流程**新建一个虚拟机**并**将虚拟机正常迁移到目标位置**
- 将自己的.vhdx文件替换目标位置刚刚迁移的虚拟机的.vhdx文件





## 更改WSL分发版的默认用户

1. **打开 WSL 分发版并获取 root 权限：**

   - **打开 WSL。**

   - **获取 root 权限：**

     ```bash
     sudo -i
     ```

2. **更改默认用户：**

   - **使用文本编辑器创建或编辑 `/etc/wsl.conf` 文件**：

     ```bash
     nano /etc/wsl.conf
     ```

   - **添加或修改 `[user]` 部分以设置默认用户**：

     在该文件中添加以下内容（如果 `wsl.conf` 文件不存在，就创建一个）：

     ```bash
     [user]
     default=username
     ```

     替换 `username` 为你想设为默认的用户名。

   - **保存并关闭文件**。

     如果你使用的是 `nano` 编辑器，可以通过按 `Ctrl+X`，然后按 `Y`，最后按 `Enter` 来保存并退出。

3. **重启 WSL**

   - **关闭所有打开的 WSL 实例**。

   - **在 Windows 命令行（CMD 或 PowerShell）中重启 WSL**：

     ```bash
     wsl --shutdown
     ```

   - **重新打开 WSL**。更改现在应该已生效。

这样设置后，当你通过 `\\wsl$` 访问 WSL 文件系统时，系统将使用你指定的默认用户。这意味着任何通过这种方式访问的文件都将使用该用户的权限和所有权。

==**注意事项：**==

- 请确保你所指定的用户名在 WSL 分发版中是存在的。
- 修改 `/etc/wsl.conf` 文件可能需要管理员权限，因此使用 `sudo` 命令。
- 重启 WSL 是必要的步骤，以确保更改被正确应用。





# 一些配置相关

## 同步wsl和宿主机时间

![image-20240418203941063](./Windows%E5%9F%BA%E4%BA%8Ewsl2%E5%AE%89%E8%A3%85linux%E5%AD%90%E7%B3%BB%E7%BB%9F.assets/image-20240418203941063.png)