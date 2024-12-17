#### 内核代码的来源

当你不在满足默认内核，想加个驱动，改个内核配置等，就需要重新编译内核。 建议使用本仓库中已经和飞腾CPU适配的内核代码。

#### 编译内核需要的工具
Ubuntu,Debian系统
```shell
sudo apt-get install build-essential libncurses-dev bison flex libssl-dev libelf-dev
```
#### arm64原生还是x86_64交叉编译
如果主机CPU是arm64的，就无需其他配置；如果是x86_64的，需要配置交叉编译环境。可以通过下面的命令查看。
```shell
uname -m
```
输出是aach64，代表arm64;输出x86_64,代表x86_54。
 

##### 交叉编译器
需要下载x86_64到arm64的交叉编译器(下面的链接），并将其解压缩到/opt目录。
https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz

##### 设置环境变量
将交叉编译器加入到程序搜索的PATH中，设定架构类型和交叉编译器的类型。
```shell
export PATH=/opt/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin:$PATH
export ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
export CC=aarch64-none-linux-gnu-gcc
```
#### 设定内核选项
首先加载默认的飞腾config，这样做的好处是飞腾相关驱动和特性会自动加入。
```shell
make phytium_defconfig
```
然后再自行修改并保存
```shell
make menuconfig
```

#### 编译
```shell
make
```

#### 生成内核镜像
编译结束后，内核镜像在 `arch/arm64/boot/`目录下，dtb文件在`arch/arm64/boot/dts/phytium`目录下

#### 收集内核模块
由于内核很多模块编译成ko，需要手工收集ko文件。请在内核当前目录下创建build目录。
```shell
mkdir build
```
设置build目录为安装目录
```shell
export INSTALL_MOD_PATH=`pwd`/build
```
安装模块
```shell
make modules_install
```
这样所用的内核模块就在`build`目录下了。
