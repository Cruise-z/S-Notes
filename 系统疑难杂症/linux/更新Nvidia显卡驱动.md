# 更新`Nvidia`显卡驱动

## 问题：

```shell
Failed to initialize NVML: Driver/library version mismatch
NVML library version: 545.29
```

这个错误表明你的 NVIDIA 驱动程序的内核模块和用户空间库之间存在版本不匹配。这通常发生在驱动程序更新不完整、多个驱动程序版本共存或内核更新后驱动程序未重新编译的情况下。



### 解决方法

**解决方案：**

为了解决这个问题，需要确保 NVIDIA 驱动程序的内核模块和用户空间库版本一致。以下是详细的步骤：

#### **步骤 1：检查当前 NVIDIA 驱动程序版本**

**1.1 检查内核模块版本**

运行以下命令查看加载的 NVIDIA 内核模块版本：

```shell
cat /proc/driver/nvidia/version
```

输出示例：

```shell
NVRM version: NVIDIA UNIX x86_64 Kernel Module  470.82.00  Tue Sep 28 16:21:02 UTC 2021
GCC version:  gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)
```

**1.2 检查用户空间库版本**

由于 `nvidia-smi` 无法运行，可以通过查看已安装的 NVIDIA 包：

```shell
dpkg -l | grep nvidia-driver
```

或

```shell
nvidia-smi -v
```

**1.3 比较版本号**

确保内核模块和用户空间库的版本号一致。如果不一致，就需要重新安装驱动程序。

------

#### **步骤 2：卸载现有的 NVIDIA 驱动程序**

**注意：在继续之前，确保你已经备份了重要数据，并准备好在必要时重启系统。**

**2.1 卸载 NVIDIA 驱动程序和相关库**

```shell
sudo apt-get purge 'nvidia-*'
sudo apt-get autoremove
```

**2.2 黑名单 Nouveau 驱动程序**

确保禁用开源的 Nouveau 驱动程序：

```shell
sudo bash -c "echo -e 'blacklist nouveau\noptions nouveau modeset=0' > /etc/modprobe.d/blacklist-nouveau.conf"
sudo update-initramfs -u
```

重启系统以应用更改：

```shell
sudo reboot
```

------

#### **步骤 3：添加官方 NVIDIA 驱动程序仓库**

**3.1 添加 NVIDIA PPA**

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
```

#### 步骤 4：安装匹配的 NVIDIA 驱动程序

- 在`软件和更新`->`附加驱动`中选取合适的驱动即可
- 输入MOK口令，重启
- 在蓝屏中选择`Enroll Key`，并输入之前的MOK口令，然后选择`continue boot`即可。