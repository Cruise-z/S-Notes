## PCIe
PCIe使用高速串行通信，相比于传统的并行总线，具有更高得数据传输速度和更好得扩展性。E2000D的PCIe控制器支持PCIe3.0规范，兼容PCIe2.0和PCIe1.0。

### 8.1. 控制器驱动加载
PCIe控制器驱动使用`module_platform_driver(gen_pci_driver)`注册驱动模块。该驱动通过ECAM实现对设备的枚举。其中`gen_pci_driver`是类型为`platform_driver`的结构体。当驱动与设备匹配成功，将执行结构体`gen_pci_driver`中的probe函数来完成最后的驱动注册工作。代码主要位于kernel/drivers/pci/controller/pci-host-generic.c。

- 驱动文件中定义了驱动结构体`gen_pci_driver`，该结构体中配置了的驱动的基本信息以及驱动probe、remove函数等：

```c
static struct platform_driver gen_pci_driver = {
	.driver = {
		.name = "pci-host-generic",
		.of_match_table = gen_pci_of_match,
	},
	.probe = pci_host_common_probe,
	.remove = pci_host_common_remove,
};

static const struct of_device_id gen_pci_of_match[] = {
	{ .compatible = "pci-host-cam-generic",
	  .data = &gen_pci_cfg_cam_bus_ops },	// 一组ECAM空间的操作函数

	{ .compatible = "pci-host-ecam-generic",
	  .data = &pci_generic_ecam_ops },

	...
};
MODULE_DEVICE_TABLE(of, gen_pci_of_match);
```

- `gen_pci_of_match`的`.compatible`将与DTS中的关键词`compatible`匹配，匹配成功后，将执行相应的probe函数。以e2000d-demo板为例，该板上的PCIe配置信息位于以下路径的设备树文件中：kernel/arch/arm64/boot/dts/phytium/pe220x.dtsi。以下是相关的设备树信息：
```dts
 pcie: pcie@40000000 {
		compatible = "pci-host-ecam-generic";
		device_type = "pci";
		#address-cells = <3>;
		#size-cells = <2>;
		#interrupt-cells = <1>;
		reg = <0x0 0x40000000 0x0 0x10000000>;
		msi-parent = <&its>;
		bus-range = <0x0 0xff>;
		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
		interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0x0 GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
						...
						<0x0 0x0 0x0 0x4 &gic 0x0 0x0 GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
		ranges = <0x01000000 0x00 0x00000000 0x0  0x50000000  0x0  0x00f00000>,
					<0x02000000 0x00 0x58000000 0x0  0x58000000  0x0  0x28000000>,
					<0x03000000 0x10 0x00000000 0x10 0x00000000 0x10  0x00000000>;
		iommu-map = <0x0 &smmu 0x0 0x10000>;
		status = "disabled";
    };
```

- 匹配成功后，将执行函数`pci_host_common_probe()`完成驱动的加载:

```c
int pci_host_common_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct pci_host_bridge *bridge;
	struct pci_config_window *cfg;
	const struct pci_ecam_ops *ops;		
	// 获取ECAM空间的操作函数
	ops = of_device_get_match_data(&pdev->dev);		
	...
	// 分配并初始化一个host bridge，后续将通过它去枚举PCIe总线上所有的设备
	bridge = devm_pci_alloc_host_bridge(dev, 0);		
	...
	// 解析映射设备树中地址资源，创建ECAM
	cfg = gen_pci_init(dev, bridge, ops);		
	...
	bridge->sysdata = cfg;
	bridge->ops = (struct pci_ops *)&ops->pci_ops;

	platform_set_drvdata(pdev, bridge);

	return pci_host_probe(bridge);
}

int pci_host_probe(struct pci_host_bridge *bridge)
{
	struct pci_bus *bus, *child;
	int ret;
	// 从bridge开始对pcie总线进行扫描并添加设备
	ret = pci_scan_root_bus_bridge(bridge);
	...
	bus = bridge->bus;			
	...
 	else {
		// 修复并对齐CPIe总线下所有PCI设备的IO和MEM地址空间
		pci_bus_size_bridges(bus);		
		// 为初始化pci设备的BAR寄存器分配资源(io、mem、prefetch)。
		pci_bus_assign_resources(bus);	

		list_for_each_entry(child, &bus->children, node)
			pcie_bus_configure_settings(child);
	}
	// 添加PCIe总线下设备的sysfs，并开始探测设备对应的驱动
	pci_bus_add_devices(bus);		
	return 0;
}
```

### 2. PCIe总线控制器基本功能测试
a. 安装工具：pciutils
pciutils是用于处理和管理PCIe总线相关的设备和信息，它提供了一系列查询、配置PCIe总线上设备的命令。
```
~# apt install pciutils
```
b. 查看PCIe总线设备信息：lspci

```
// 显示pcie总线上的设备, 以及一些信息
~# lspci -kv 

// 查看pcie链路状态,回读pcie链路状态为速率：8GT/s，链路宽度x4。
~# lspci -vvv -s <PCI address or slot number>	

```
c. 读取和设置PCIe设备的配置寄存器：setpci

```
// 写02:00.0设备，0x50位置，一个byte长度的值为6，-D代表仅测试，不会真正写下去
~# setpci -vD -s 02:00.0 50.B=6
```
