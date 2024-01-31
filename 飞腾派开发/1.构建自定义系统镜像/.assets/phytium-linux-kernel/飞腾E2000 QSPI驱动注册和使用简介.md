## QSPI
QSPI是一种串行外设接口，提供了一种用于连接微控制器（MCU）或处理器与外部设备（如闪存、传感器等）的通信标准。QSPI是SPI的改进版本，通过增加数据线的数量来提高数据传输速度。

### 1. 控制器驱动注册
QSPI控制器驱动使用`module_platform_driver(phytium_qspi_driver)`注册驱动模块。其中`phytium_qspi_driver`是类型为`platform_driver`的结构体。当驱动与设备匹配成功，将执行结构体`phytium_qspi_driver`中的probe函数来完成最后的驱动注册工作。代码主要位于kernel/drivers/mtd/spi-nor/controllers/phytium-quadspi.c。

- 驱动文件中定义了驱动结构体`phytium_qspi_driver`，该结构体中配置了的驱动的基本信息以及驱动probe、remove函数等：

```c
static struct platform_driver phytium_qspi_driver = {
	.probe	= phytium_qspi_probe,
	.remove	= phytium_qspi_remove,
	.driver	= {
		.name = "phytium-quadspi",
		.of_match_table = phytium_qspi_match,
		...
	},
};

static const struct of_device_id phytium_qspi_match[] = {
	{ .compatible = "phytium,qspi" },
	{ }
};
MODULE_DEVICE_TABLE(of, phytium_qspi_match);
```

- `phytium_qspi_match`的`.compatible`将与DTS中的关键词`compatible`匹配，匹配成功后，将执行相应的probe函数。以e2000d-demo板为例，该板上的QSPI配置信息位于以下路径的设备树文件中：kernel/arch/arm64/boot/dts/phytium/pe2202.dtsi。以下是相关的设备树信息：
```dts
qspi0: spi@28008000 {
		compatible = "phytium,qspi";
		reg = <0x0 0x28008000 0x0     0x1000>,
				<0x0        0x0 0x0 0x0fffffff>;
		reg-names = "qspi", "qspi_mm";
		clocks = <&sysclk_50mhz>;
		#address-cells = <1>;
		#size-cells = <0>;
		status = "disabled";

		flash@0 { 
				reg = <0>;
				spi-rx-bus-width = <1>;
				spi-max-frequency = <50000000>;
				status = "disabled";
		};
};

// 状态配置
&qspi0 {
        status = "okay";

        flash@0 {
                status = "okay";
        };
};
```

- 匹配成功后，将执行函数`phytium_qspi_probe()`完成驱动的加载:

```c
static int phytium_qspi_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct fwnode_handle *flash_np;
	struct phytium_qspi *qspi;
	struct resource *res;
	int ret;

	qspi = devm_kzalloc(dev, sizeof(*qspi), GFP_KERNEL);
	...
	// 获取设备树中控制器下的子节点数目
	qspi->nor_num = device_get_child_node_count(dev);	
	if (!qspi->nor_num || qspi->nor_num > PHYTIUM_MAX_NORCHIP)
		return -ENODEV;
	// 通过设备树方式启动，根据关键字匹配qspi的iomem资源，并进行映射，将对应的虚拟地址填充到结构体qspi中
	if (dev->of_node)		
		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi");		
	...
	qspi->io_base = devm_ioremap_resource(dev, res);
	...
	if (dev->of_node)
		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qspi_mm");
	...
	qspi->mm_base = devm_ioremap_resource(dev, res);
	...
	// 获取设备树中clocks信息
	if (dev->of_node) {
		qspi->clk = devm_clk_get(dev, NULL);			
		...
		qspi->clk_rate = clk_get_rate(qspi->clk);
		...
		ret = clk_prepare_enable(qspi->clk);
		...
	}
	...
	qspi->dev = dev;
	platform_set_drvdata(pdev, qspi);
	...
	// 遍历子节点
	fwnode_for_each_available_child_node(dev_fwnode(dev), flash_np) {
		// 根据设备树子节点对falsh进行设置
		ret = phytium_qspi_flash_setup(qspi, flash_np);		
		...
	}
	...
}
```

### 2. QSPI Flash 读写测试
a. 预备工作：安装工具mtd-utils

```
~# sudo apt install mtd-utils
```
接下来需要阅读设备树相关代码与驱动文件drivers/mtd/spi-nor/boya.c进行以下两点确认：
- 设备树中是否打开了flash0：`flash@0{status = “okay”;}`，若不存在，请添加；
- 驱动文件中是否存在`{ "by25q128as",  INFO(0x684018, 0, 64 * 1024, 256, SECT_4K) }`，若不存在，请添加；

b. 读测试
- 查看mtd设备

```
~# cat /proc/mtd		// qspi用作spi nor被放在mtd下

~# mtd_debug info /dev/mtd0  // 输出/dev/mtd0上的相关信息

```

- 从mtdblock0中读data

```
~# mtd_debug read  /dev/mtdblock0 0x0 0x1000 read.data
```
  
c. 写测试

- 擦除数据

```
~# mtd_debug erase /dev/mtdblock0 0x0 0x1000
```

- 写随机值

```
// 读出默认的数据
~# mtd_debug read  /dev/mtdblock0 0x0 0x1000 read.data

// 写入随机值
~# mtd_debug write /dev/mtdblock0 0x0 0x1000 /dev/urandom

// 读出新写入的数据
~# mtd_debug read  /dev/mtdblock0 0x0 0x1000 read.data2

// 将读取的新数据与旧数据read.data1比较，来确定是否写入新数据
~# diff read.data2 read.data 
```

- 烧写固件

```
mtd_debug write  /dev/mtdblock0 0x0 0x6afe10  <file-path>
```
