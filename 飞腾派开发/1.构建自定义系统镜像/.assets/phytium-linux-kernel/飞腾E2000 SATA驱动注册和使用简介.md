## SATA

SATA是一种串行计算机总线接口，用于连接计算机内部的存储设备，如固态硬盘（SSDs）。E2000系列支集成的SATA控制器兼容SATA3.0规范的接口，支持连接1.5Gb/s、3.0Gb/s、6.0Gb/s 的SATA设备，工作在6.0Gb/s 速率模式时连续顺序读带宽可达500MB/s，连续顺序写带宽可达470MB/s。本控制器寄存器兼容AHCI1.3的HBA MEMORY寄存器部分，但无HBA
CONFIGURATION寄存器部分(pci 部分)，主机软件在访问寄存器接口时遵循相关的标准和约定，并遵循标准的命令协议约定。

### 1. 控制器驱动注册
SATA控制器驱动使用`module_platform_driver(ahci_driver)`注册驱动模块。其中`ahci_driver`是类型为`platform_driver`的结构体。当驱动与设备匹配成功，将执行结构体`ahci_driver`中的probe函数来完成最后的驱动注册工作。代码主要位于kernel/drivers/ata/ahci_platform.c

- 驱动文件中定义了驱动结构体`ahci_driver`，该结构体中配置了的驱动的基本信息以及驱动probe、remove函数等：
```c
static struct platform_driver ahci_driver = {
	.probe = ahci_probe,
	...
	.driver = {
		.name = DRV_NAME,
		.of_match_table = ahci_of_match,
		.acpi_match_table = ahci_acpi_match,
		.pm = &ahci_pm_ops,
	},
};

static const struct of_device_id ahci_of_match[] = {
	{ .compatible = "generic-ahci", },
	/* Keep the following compatibles for device tree compatibility */
	{ .compatible = "snps,spear-ahci", },
	...
};

// acpi匹配表
static const struct acpi_device_id ahci_acpi_match[] = {
	{ "APMC0D33", (unsigned long)&ahci_port_info_nolpm },
	{ ACPI_DEVICE_CLASS(PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff) },
	{},
};
MODULE_DEVICE_TABLE(of, ahci_of_match);
```

- ahci_of_match的.compatible将与DTS中的关键词compatible匹配，匹配成功后，将执行相应的probe函数。以e2000d-demo板为例，该板上的QSPI配置信息位于以下路径的设备树文件中：kernel/arch/arm64/boot/dts/phytium/pe2202.dtsi。以下是相关的设备树信息：

```dts
sata0: sata@31a40000 {
                compatible = "generic-ahci";
                reg = <0x0 0x31a40000 0x0 0x1000>;
                interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
                status = "disabled";
        };

```
- 匹配成功后，将执行函数`ahci_probe()`完成驱动的加载:

``` c
static int ahci_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct ahci_host_priv *hpriv;
	const struct ata_port_info *port;
	int rc;
	// 新建结构体hpriv，并从设备树中获取io mem等资源
	hpriv = ahci_platform_get_resources(pdev,
					    AHCI_PLATFORM_GET_RESETS);
	...
	
	rc = ahci_platform_enable_resources(hpriv);
	...
	// 通过acpi方式匹配，并获取ahci_acpi_match中的port_info
	port = acpi_device_get_match_data(dev);
	...
	// 初始化host
	rc = ahci_platform_init_host(pdev, hpriv, port,
				     &ahci_platform_sht);
	...
}
```

### 2. SATA接口使用
将SATA盘连接e2000板中的SATA接口与对应的电源进行供电，进入系统后，系统能够识别出SATA盘。
```
~# lsblk
```
