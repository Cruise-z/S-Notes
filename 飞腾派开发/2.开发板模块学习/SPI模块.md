# SPI模块

> **参考：**
>
> -    [CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf](.assets/CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf) 
> -    [CEK8902原理图_v3_sch.pdf](.assets/CEK8902原理图_v3_sch.pdf) 



- 将编译得到的内核设备树二进制文件`.dtb`反编译为`.dts`：

  > `dtc`（Device Tree Compiler）在进行反编译时会根据输入的设备树二进制文件的架构进行适配。设备树二进制文件（`.dtb`）是与硬件架构相关的二进制表示，因此在反编译时，`dtc` 会根据文件的架构信息正确解析设备树的结构。
  >
  > 当你使用 `dtc` 反编译设备树二进制文件时，`dtc` 会自动检测文件的架构，并使用相应的解析规则。这意味着无需手动指定目标架构，`dtc` 会根据文件的头部信息确定设备树的格式和架构。
  >
  > 例如，如果你有一个 `ARM` 架构的设备树二进制文件，`dtc` 将会使用 `ARM` 架构的规范来反编译该文件。同样，如果你有一个 `x86` 架构的设备树二进制文件，`dtc` 将使用 `x86` 架构的规范来解析。
  >
  > - 你可以通过以下命令使用 `dtc` 反编译设备树二进制文件：
  >
  >   ```shell
  >   dtc -I dtb -O dts -o output_file.dts input_file.dtb
  >   ```
  >
  >   这里的 `-I dtb` 表示输入文件是设备树二进制文件，而 `-O dts` 表示输出文件是设备树源文件。`dtc` 会自动识别设备树二进制文件的架构并进行相应的反编译。
  >
  > - 同理可以通过以下命令利用`.dts`文件编译出设备树二进制文件：
  >
  >   ```shell
  >   dtc -I dts -O dtb -o output_file.dts input_file.dtb
  >   ```

- 修改`.dts`文件中设备树 `spidev0`的 `status`为`okay`

- 根据更改的`.dts`文件编译出新的`.dtb`文件

- 将其拷贝到`/boot`目录下，参考 [编译内核.md](../1.构建自定义系统镜像/编译内核.md) 中`替换内核`方法更改`uboot`启动配置加载新的设备树

  - 这是替换前的`uboot`配置参数：<img src="./SPI%E6%A8%A1%E5%9D%97.assets/image-20240125170955956.png" alt="image-20240125170955956" style="zoom:50%;" />

  - 修改`bootcmd`参数：

    ```bash
    E2000# setenv bootcmd 'mmc dev 0; mmc read 0x90000000 0x2000 0x10000; ext4load mmc 0:1 0x90100000 boot/phytiumpi_firefly.dtb; bootm 0x90000000 – 0x90100000#phytium;';
    ```

    
