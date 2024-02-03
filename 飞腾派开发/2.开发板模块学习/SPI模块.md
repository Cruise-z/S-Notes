# SPI模块

> **参考：**
>
> -    [CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf](.assets/CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf) 
> -    [CEK8902原理图_v3_sch.pdf](.assets/CEK8902原理图_v3_sch.pdf) 



## 模拟spi服务

**模拟spi服务需要修改并生成新的设备树文件进行替换：**

### 方法

#### 修改并替换设备树

- 编译生成的内核位于：`phytium-pi-os/output/build/linux-custom/`目录下：

  - `Image`文件位于内核目录下的`arch/arm64/boot`目录内
  
  - 设备树文件位于内核目录下的`arch/arm64/boot/dts/phytium`目录内
  
    修改`.dts`：打开设备树`spidev0`的`status`为`okay`，编译后更新设备树，就能获得一个模拟的外设：![image-20240129161508794](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240129161508794.png)
  
- 根据更改的`.dts`文件编译出新的`.dtb`文件：

  > 参考： [设备树dts和dtb文件的转换.md](../1.构建自定义系统镜像/.assets/phytium-linux-kernel/设备树dts和dtb文件的转换.md) 
  >
  > > `dtc`（Device Tree Compiler）在进行反编译时会根据输入的设备树二进制文件的架构进行适配。设备树二进制文件（`.dtb`）是与硬件架构相关的二进制表示，因此在反编译时，`dtc` 会根据文件的架构信息正确解析设备树的结构。
  > >
  > > 当你使用 `dtc` 反编译设备树二进制文件时，`dtc` 会自动检测文件的架构，并使用相应的解析规则。这意味着无需手动指定目标架构，`dtc` 会根据文件的头部信息确定设备树的格式和架构。
  > >
  > > 例如，如果你有一个 `ARM` 架构的设备树二进制文件，`dtc` 将会使用 `ARM` 架构的规范来反编译该文件。同样，如果你有一个 `x86` 架构的设备树二进制文件，`dtc` 将使用 `x86` 架构的规范来解析。
  > >
  > > - 你可以通过以下命令使用 `dtc` 反编译设备树二进制文件：
  > >
  > >   ```shell
  > >   dtc -I dtb -O dts -o output_file.dts input_file.dtb
  > >   ```
  > >
  > >   这里的 `-I dtb` 表示输入文件是设备树二进制文件，而 `-O dts` 表示输出文件是设备树源文件。`dtc` 会自动识别设备树二进制文件的架构并进行相应的反编译。
  > >
  > > - 同理可以通过以下命令利用`.dts`文件编译出设备树二进制文件：
  > >
  > >   ```shell
  > >   dtc -I dts -O dtb -o output_file.dtb input_file.dts
  > >   ```
  >

  - 我们在内核目录：`phytium-pi-os/output/build/linux-custom/`下执行：

    ```shell
    make dtbs
    ```

    即可生成新的设备树二进制(`.dtb`)文件。

- 将**内核映像**以及**新的设备树文件**拷贝到`/boot`目录下：

  - 内核映像位于：内核目录下的`arch/arm64/boot/Image`
  - 生成的设备树二进制文件位于内核目录下的`arch/arm64/boot/dts/phytium`文件夹内：![image-20240131101456428](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240131101456428.png)
  
- 加载新的设备树：

  > 参考 [编译内核.md](../1.构建自定义系统镜像/编译内核.md) 中`替换内核`方法更改`uboot`启动配置加载新的设备树

  - 这是替换前的`uboot`配置参数：<img src="./SPI%E6%A8%A1%E5%9D%97.assets/image-20240125170955956.png" alt="image-20240125170955956" style="zoom:50%;" />

  - 修改`bootcmd`参数：
  
    将内核映像以及新有的设备树加载之后再启动：
    
    ```bash
    E2000# setenv bootcmd 'ext4load mmc 0:1 0x90100000 boot/Image; ext4load mmc 0:1 0x90000000 boot/phytiumpi_firefly.dtb; booti 0x90100000 – 0x90000000#phytium;';
    ```
    
    > 1. **`ext4load mmc 0:1 0x90100000 boot/Image;`：**
    >    - 从 MMC 存储设备的第一个分区（`mmc 0:1`）加载名为 `Image` 的文件到内存地址 `0x90100000`。
    >    - 这通常是加载 Linux 内核映像的步骤。
    > 2. **`ext4load mmc 0:1 0x90000000 boot/phytiumpi_firefly.dtb;`：**
    >    - 从 MMC 存储设备的第一个分区（`mmc 0:1`）加载名为 `phytiumpi_firefly.dtb` 的设备树文件到内存地址 `0x90000000`。
    >    - 这是加载设备树文件的步骤，该文件描述了硬件设备和内核参数。
    > 3. **`booti 0x90100000 – 0x90000000#phytium;`：**
    >    - 使用 `booti` 命令引导 Linux 内核。
    >    - 指定内核的加载地址为 `0x90100000`，设备树的加载地址为 `0x90000000`。
    >    - `#phytium` 可能是一个注释，表示特定于 Phytium 的信息。
    >
    
  - 保存`bootcmd`参数：
  
    ```shell
    E2000# saveenv;
    ```
  
  - 重新启动即可



#### 生成spi测试工具并测试

- `spidev_test`的源码在内核目录下的 `tools/spi/spidev_test.c`

  在本目录下执行`make`命令：

  ![image-20240203100219206](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240203100219206.png)

  将这个文件拷贝到开发板平台下即可。

- 找到spi模块的接收和发送引脚：

  参考：[CEK8902原理图_v3_sch.pdf](.assets/CEK8902原理图_v3_sch.pdf) ：![image-20240203101227959](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240203101227959.png)

- 在开发板平台上测试spi：

  在spi测试工具所在目录下执行如下命令运行测试工具：

  ```shell
  sudo ./spidev_test -D /dev/spidev0.0 -v
  ```

  - 短接收发引脚时：![image-20240203131624369](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240203131624369.png)
  
    `RX`收到的数据和`TX`一样，说明`SPI`自发自收正常；通过示波器也能看到`SPI`数据传送波形 。
  
  - 断开`SPI`的`TX` `RX` ，再运行测试`RX`收不到`TX`的数据：![image-20240203132131916](./SPI%E6%A8%A1%E5%9D%97.assets/image-20240203132131916.png)
  
    

