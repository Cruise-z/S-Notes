# Phytium Pi OS
飞腾派OS（Phytium Pi OS）是运行在飞腾派开发板上的深度定制的Linux系统（基于Debian11）。它针对飞腾派开发板的硬件定制了内核配置，不同的软件包，可以更好的适应不同的场景。
它可以烧录在SD卡中，作为飞腾派开发板的启动系统。  
飞腾派OS由Buildroot生成，获取更多Buildroot的信息，可参考用户手册docs/manual/manual.pdf。

# 开发环境
## 系统要求
Buildroot被设计为在x86 Linux系统上运行，结合其他因素，本仓库只支持在ubuntu20.04、ubuntu22.04、debian11这三种x86系统上进行开发，不支持其他系统。
首先，Buildroot需要主机系统上安装如下Linux程序，请检查是否已安装：
```
• Build tools:
– which
– sed
– make (version 3.81 or any later)
– binutils
– build-essential (only for Debian based systems)
– gcc (version 4.8 or any later)
– g++ (version 4.8 or any later)
– bash
– patch
– gzip
– bzip2
– perl (version 5.8.7 or any later)
– tar
– cpio
– unzip
– rsync
– file (must be in /usr/bin/file)
– device-tree-compiler
– bc
• Source fetching tools:
– wget
– git
```
除此之外，还需要安装如下软件包：  
`$ sudo apt install debootstrap qemu-user-static binfmt-support debian-archive-keyring`  
对于debian11系统，需要设置PATH环境变量：`PATH=$PATH:/usr/sbin`  

## 下载Phytium Pi OS
`$ git clone https://gitee.com/phytium_embedded/phytium-pi-os`  
克隆后，将会生成phytium-pi-os目录，我们称之为源码根目录，若无另外说明，下面的操作命令都是基于该源码根目录进行描述的
# 查看支持的defconfig
为飞腾派构建的文件系统的配置文件位于configs目录。  
执行`$ make list-defconfigs`，返回configs目录中的defconfig配置文件。  
```
$ cd xxx/phytium-pi-os
$ make list-defconfigs
```
其中以phytiumpi开头的为飞腾相关的defconfig配置文件，包含：  
```
phytiumpi_defconfig      - Build for phytiumpi
phytiumpi_desktop_defconfig - Build for phytiumpi with desktop
```

# 编译文件系统
## 为phytiumpi编译文件系统
### 编译默认配置的文件系统
（1）加载defconfig   
`$ make phytiumpi_xxx_defconfig`  
其中`phytiumpi_xxx_defconfig`为以下文件系统之一：
```
phytiumpi_defconfig
phytiumpi_desktop_defconfig
```  
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、sdcard.img 镜像位于output/images目录。 

#### phytiumpi img 镜像
支持编译phytiumpi img 镜像（sdcard.img），生成的phytiumpi img 镜像位于output/images目录。sdcard.img 镜像包含了根文件系统、内核、设备树。
使用sdcard.img 镜像安装系统，不需要将存储设备手动分区再拷贝文件，只需要将sdcard.img文件写入存储设备即可。  

### 更换文件系统的linux内核版本
defconfig中的内核版本默认是linux 5.10。我们支持在编译文件系统时将内核版本更换为linux 4.19，linux 4.19 rt，linux 5.10 rt。
关于phytiumpi linux内核的信息请参考：`https://gitee.com/phytium_embedded/phytium-linux-kernel`  
更换内核版本的操作步骤为：  
（1）使用phytiumpi_xxx_defconfig作为基础配置项，合并支持其他内核版本的配置：  
`$ ./support/kconfig/merge_config.sh configs/phytiumpi_xxx_defconfig configs/phytiumpi_linux_xxx.config`  
其中`configs/phytiumpi_linux_xxx.config`为以下配置片段文件之一：
```
configs/phytiumpi_linux_4.19.config
configs/phytiumpi_linux_4.19_rt.config
configs/phytiumpi_linux_5.10_rt.config
```
这三个文件分别对应于linux 4.19，linux 4.19 rt，linux 5.10 rt内核。  
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、sdcard.img 镜像位于output/images目录。

### 支持Phytium-optee
本项目还支持编译Phytium-optee，关于Phytium-optee的信息请参考：`https://gitee.com/phytium_embedded/phytium-optee`
defconfig默认不编译Phytium-optee，如果需要编译Phytium-optee请执行：  
（1）使用phytiumpi_xxx_defconfig作为基础配置项，合并支持optee的配置：  
`$ ./support/kconfig/merge_config.sh configs/phytiumpi_xxx_defconfig configs/phytiumpi_optee.config`  
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、TEE OS位于output/images目录。  
后续部署及使用方法，请参考`https://gitee.com/phytium_embedded/phytium-embedded-docs/tree/master/optee`

### 支持xenomai
本项目还支持编译xenomai，关于xenomai的信息请参考：`https://gitee.com/phytium_embedded/linux-kernel-xenomai`  
支持将xenomai内核及用户态的库、工具编译安装到debian系统上。如果需要编译xenomai请执行：  
（1）使用phytiumpi_xxx_defconfig作为基础配置项，合并支持xenomai的配置：  
`$ ./support/kconfig/merge_config.sh configs/phytiumpi_xxx_defconfig configs/phytiumpi_xenomai_xxx.config`  
其中，`phytiumpi_xxx_defconfig`为`phytiumpi_defconfig`或`phytiumpi_desktop_defconfig`；  
`phytiumpi_xenomai_xxx.config`为以下配置片段文件之一：
```
phytiumpi_xenomai_cobalt_4.19.config  （xenomai cobalt 4.19内核+xenomai-v3.1.3.tar.gz）
phytiumpi_xenomai_cobalt_5.10.config  （xenomai cobalt 5.10内核+xenomai-v3.2.2.tar.gz）
phytiumpi_xenomai_mercury_4.19.config （linux 4.19 rt内核+xenomai-v3.1.3.tar.gz）
phytiumpi_xenomai_mercury_5.10.config （linux 5.10 rt内核+xenomai-v3.2.2.tar.gz）
```
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、sdcard.img 镜像位于output/images目录。  
（4）文件的安装路径  
xenomai用户态的库、工具被安装到根文件系统的/usr/xenomai目录。  
关于xenomai的启动及测试工具等更多信息，请参考`https://gitee.com/phytium_embedded/phytium-embedded-docs/tree/master/xenomai`   

### 支持ethercat
本项目还支持编译ethercat，关于ethercat的信息请参考：`https://gitee.com/phytium_embedded/ether-cat`  
支持将ethercat驱动及用户态的库、工具编译安装到debian系统上，ethercat只支持linux 4.19 rt，linux 5.10 rt内核。如果需要编译ethercat请执行：  
（1）使用phytiumpi_xxx_defconfig作为基础配置项，合并支持rt内核，及ethercat的配置：  
`./support/kconfig/merge_config.sh configs/phytiumpi_xxx_defconfig configs/phytiumpi_linux_xxx_rt.config configs/phytiumpi_ethercat.config`  
其中，`phytiumpi_xxx_defconfig`为`phytiumpi_defconfig`或`phytiumpi_desktop_defconfig`；  
`phytiumpi_linux_xxx_rt.config`为`phytiumpi_linux_4.19_rt.config`或`phytiumpi_linux_5.10_rt.config`。  
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、sdcard.img 镜像位于output/images目录。  
（4）文件的安装路径  
将ethercat的驱动模块安装到根文件系统的/lib/modules/version/ethercat/目录，并且通过将ec_macb加入/etc/modprobe.d/blacklist.conf
黑名单的方式，使得开机时不自动加载ec_macb模块，而是让用户手动加载。  
ethercat用户态的库、工具被安装到根文件系统：  
配置文件安装到/etc，其它内容分别被安装到/usr目录下的bin，include，lib，sbin，share。  
关于ethercat的使用方法等更多信息，请参考`https://gitee.com/phytium_embedded/phytium-embedded-docs/tree/master/ethercat`  

### 支持5G
飞腾派适配了移远通信 RG200U-CN MINIPCIE 5G模块。使用默认配置文件phytiumpi_xxx_defconfig，编译的SD卡镜像不支持5G上网功能。如果需要使用
RG200U-CN MINIPCIE 5G模块上网，需要重新编译生成SD卡镜像。  
（1）使用phytiumpi_xxx_defconfig作为基础配置项，合并支持5G模块的配置：  
`./support/kconfig/merge_config.sh configs/phytiumpi_desktop_defconfig configs/phytiumpi_5g.config`  
（2）编译  
`$ make`  
（3）镜像的输出位置  
生成的根文件系统、内核、sdcard.img 镜像位于output/images目录。  
关于使用5G模块上网的详细步骤，请参考本仓库的wiki。

## 清理编译结果
（1）`$ make clean`  
删除所有编译结果，包括output目录下的所有内容。当编译完一个文件系统后，编译另一个文件系统前，需要执行此命令。  
（2）`$ make distclean`  
重置源码根目录，删除所有编译结果、下载目录以及配置。  

## 树外构建
默认情况下，编译生成的所有内容都存储在output目录，然而，树外构建允许使用除output以外的其他输出目录。使用树外构建时，全局配置文件.config和临时文件也存储在输出目录中。这意味着使用相同的源码树，只要使用不同的输出目录，就可以并行运行多个构建。  
使用树外构建进行配置的方式有以下三种可供选择：  
（1）在源码根目录下，使用O变量指定输出目录：  
`$ make O=xxx/foo-output phytiumpi_xxx_defconfig`  
（2）在一个空的输出目录运行，指定O变量和源码根目录的路径：  
`$ mkdir xxx/foo-output`  
`$ cd xxx/foo-output`  
`$ make -C xxx/phytium-pi-os/ O=$(pwd) phytiumpi_xxx_defconfig`  
（3）对于使用merge_config.sh合并配置文件的情况，在源码根目录运行：  
`$ mkdir xxx/foo-output`  
`$ ./support/kconfig/merge_config.sh -O xxx/foo-output configs/phytiumpi_xxx_defconfig configs/phytiumpi_xxx.config`  

运行上述命令之一，会在输出目录中创建一个Makefile，所以在输出目录中再次运行make时，不再需要指定O变量和源码根目录的路径。  
因此配置完成后，编译的命令为：  
`$ cd xxx/foo-output`  
`$ make`   

## 修改内核进行编译  
默认的内核源码目录是`output/build/linux-<version>`，如果在该目录对内核进行了修改（例如修改内核配置或源码），
当运行`make clean`后该目录会被删除，所以在该目录中直接修改内核是不合适的。  
因此，对于这种情况提供了一种机制：`<PKG>_OVERRIDE_SRCDIR`机制。  
操作方法是，创建一个叫做local.mk的文件，其内容是：
```
$ cat local.mk 
LINUX_OVERRIDE_SRCDIR = /home/xxx/linux-kernel
```
将local.mk文件和.config文件放在同一目录下，对于树内构建是源码根目录，对于树外构建是树外构建的输出目录。  
LINUX_OVERRIDE_SRCDIR指定了一个本地的内核源码目录，这样就不会去下载、解压、打补丁内核源码了，而是使用LINUX_OVERRIDE_SRCDIR
指定的内核源码目录。   
这样开发人员首先在LINUX_OVERRIDE_SRCDIR指定的目录对内核进行修改，然后运行`make linux-rebuild`或者 `make linux-reconfigure`即可。
该命令首先将LINUX_OVERRIDE_SRCDIR中的内核源码同步到`output/build/linux-custom`目录，然后进行配置、编译、安装。  
如果想要编译、安装内核，并重新生成系统镜像，请运行`make linux-rebuild all`。  

# 在开发板上启动文件系统
## 在phytiumpi开发板上启动文件系统
### 使用U-Boot启动文件系统（使用phytiumpi img 镜像）
（1）将phytiumpi img 镜像（sdcard.img）写入sd卡：  
`$ sudo dd if=xxx/phytium-pi-os/output/images/sdcard.img of=/dev/sdb bs=1M`  

本项目还提供了将img镜像烧录进sd卡并进行md5值校验的脚本，确保烧录正确。该脚本需在顶层目录下执行，用法为以下其中之一：  
`$ sudo ./board/phytium/dd_and_checkMD5.sh /dev/sdx desktop`   
`$ sudo ./board/phytium/dd_and_checkMD5.sh /dev/sdx no_desktop`  
其中，/dev/sdx表示sd卡对应的设备节点名称；  
如果编译的是phytiumpi_desktop_defconfig，使用第一条命令；  
如果编译的是phytiumpi_defconfig，使用第二条命令。  
（2）SD卡接到开发板，启动开发板电源，启动文件系统  
（3）登陆开发板，执行lsblk 命令查看磁盘分区信息,SD 卡对应盘符为 /dev/mmcblk0.
  需要将根目录分区 /dev/mmcblk0p1 进行扩容:
  `$ source /usr/bin/resize.sh`
  需重启生效  
（4）开发板运行时，如果需要更换uboot、Image和dtb，本项目提供了对应脚本，用法如下：  
`$ sudo runtime_replace_bootloader.sh all`  
`$ sudo runtime_replace_bootloader.sh uboot`  
`$ sudo runtime_replace_bootloader.sh image`  
以上三条命令分别实现了更换uboot+image+dtb、更换uboot和更换image+dtb的功能，要求当前目录下有fip-all.bin和fitImage文件。  

# 系统支持linux-headers
linux-headers包含构建内核外部模块所需的头文件，编译defconfig会生成linux-headers。  
关于如何编译内核外部模块，可参考https://www.kernel.org/doc/html/latest/kbuild/modules.html  

## 交叉编译内核模块
编译phytiumpi_xxx_defconfig，会在`output/target/usr/src`目录中安装linux-headers-version。   
使用工具链来交叉编译内核模块，工具链位于`output/host/bin`，工具链的sysroot为
`output/host/aarch64-buildroot-linux-gnu/sysroot`。  

交叉编译内核外部模块的命令为：
```
$ make ARCH=arm64 \
CROSS_COMPILE=/home/xxx/phytium-pi-os/output/host/bin/aarch64-none-linux-gnu- \
-C /home/xxx/phytium-pi-os/output/target/usr/src/linux-headers-5.10.153-phytium-embeded \
M=$PWD \
modules
```

## 开发板上编译内核模块
编译完成后，linux-headers-version被安装在根文件系统的`/usr/src`目录下，
并为它创建了一个软链接`/lib/modules/version/build`。  
注意，由于linux-headers是在x86-64主机交叉编译生成的，在开发板上直接使用它编译内核模块会报错：  
`/bin/sh: 1: scripts/basic/fixdep: Exec format error`。  
因此，需要将x86-64格式的fixdep等文件替换为ARM aarch64格式的（以linux 5.10内核为例）：  
（1）`scp -r username@host:/home/xxx/phytium-pi-os/board/phytium/common/linux-5.10/scripts /usr/src/linux-headers-5.10.153-phytium-embeded`  
（2）或者在编译phytiumpi_xxx_defconfig之前，将board/phytium/common/post-custom-skeleton-debian-base-11.sh中的如下两行取消注释，再执行编译。  
`# cp -r board/phytium/common/linux-5.10/scripts $destdir`  
`# cp -r board/phytium/common/linux-4.19/scripts $destdir`  

在开发板上编译内核外部模块的命令为：  
`make -C /lib/modules/5.10.153-phytium-embeded/build M=$PWD modules`

# 编译新的应用软件
本节简单介绍如何交叉编译出能够运行在飞腾派开发板上的应用软件，完整的教程请参考用户手册docs/manual/manual.pdf。  
## 软件包介绍
所有用户态的软件包都在package目录，每个软件包有自己的目录`package/<pkg>`，其中`<pkg>`是小写的软件包名。这个目录包含：  
（1）`Config.in`文件，用Kconfig语言编写，描述了包的配置选项。  
（2）`<pkg>.mk`文件，用make编写，描述了包如何构建，即从哪里获取源码，如何编译和安装等。  
（3）`<pkg>.hash`文件，提供hash值，检查下载文件的完整性，如检查下载的软件包源码是否完整，这个文件是可选的。  
（4）`*.patch`文件，在编译之前应用于源码的补丁文件，这个文件是可选的。  
（5）可能对包有用的其他文件。
## 编写软件包
首先创建软件包的目录`package/<pkg>`，然后编写该目录下的文件。  
一般情况下，`package/<pkg>`下有`Config.in`和`<pkg>.mk`两个文件。关于如何编写这两个文件，大家可以参考`package/<vpu-lib>`和
用户手册docs/manual/manual.pdf，这里简单概括一下。  
（1）`Config.in`文件中必须包含启用或禁用该包的选项，而且必须命名为`BR2_PACKAGE_<PKG>`，其中`<PKG>`是大写的软件包名，这个选项的值是布尔类型。
也可以定义其他功能选项来进一步配置该软件包。然后还必须在`package/Config.in`文件中包含该文件：  
`source "package/<pkg>/Config.in"`  
（2）`<pkg>.mk`文件看起来不像普通的Makefile文件，而是一连串的变量定义，而且必须以大写的包名作为变量的前缀。最后以调用软件包的基础结构（package
infrastructure）结束。变量告诉软件包的基础结构要做什么。  
对于使用手写Makefile来编译的软件源码，在`<pkg>.mk`中调用generic-package基础结构。generic-package基础结构实现了包的下载、提取、打补丁。
而配置、编译和安装由`<pkg>.mk`文件描述。`<pkg>.mk`文件中可以设置的变量及其含义，请参考用户手册docs/manual/manual.pdf。  
## 编译软件包 
（1）单独编译软件包
```
$ cd xxx/phytium-pi-os
$ make <pkg>
```
编译结果在`output/build/<pkg>-<version>`  

（2）将软件包编译进根文件系统
```
在phytiumpi_xxx_defconfig中添加一行BR2_PACKAGE_<PKG>=y
$ make phytiumpi_xxx_defconfig
$ make
```

# FAQ
1、关于phytium pi vpu的包请咨询飞腾技术支持或FAE。  
