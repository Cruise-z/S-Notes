## UART
E2000-demo板集成了9线UART控制器、5线UART控制器以及3线控制器，其中3线控制器由MIO配置实现。

### 1. 控制器驱动注册

UART控制器驱动使用`arch_initcall(pl011_init)`注册驱动模块。函数`pl011_init()`会调用`amba_driver_register(&pl011_driver)`来向amba总线注册UART驱动。当驱动与设备匹配成功，将执行结构体`amba_driver`中的probe函数来完成最后的驱动注册工作。代码主要位于kernel/drivers/tty/serial/amba-pl011.c。

- 驱动文件中定义了amba 总线的驱动结构体`pl011_driver`，该结构体中配置了的驱动的基本信息以及驱动probe、remove函数等：
```c
static struct amba_driver pl011_driver = {
	.drv = {
		.name	= "uart-pl011",
		...	
	},
	.id_table	= pl011_ids,
	.probe		= pl011_probe,
	.remove		= pl011_remove,
};

static const struct amba_id pl011_ids[] = {
	{
		.id	= 0x00041011,
		.mask	= 0x000fffff,
		.data	= &vendor_arm,
	},
	...
};

MODULE_DEVICE_TABLE(amba, pl011_ids);
```

- `pl011_ids`的`id`在设备与驱动绑定时会与设备的`periphid`属性匹配，匹配成功后，将执行相应的probe函数。以e2000d-demo板为例，该板上的UART配置信息位于以下路径的设备树文件中：kernel/arch/arm64/boot/dts/phytium/pe220x.dtsi。以下是相关的设备树信息：
```dts
uart0: uart@2800c000 {
		compatible = "arm,pl011","arm,primecell";
		reg = <0x0 0x2800c000 0x0 0x1000>;
		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
		clocks = <&sysclk_100mhz &sysclk_100mhz>;
		clock-names = "uartclk", "apb_pclk";
		status = "disabled";
};
                ...
```

- `pl011_probe()`对UART设备进行初始化、配置、资源分配以及将其注册到Linux设备模型中。
```c
static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
{
	struct uart_amba_port *uap;
	struct vendor_data *vendor = id->data;
	int portnr, ret;
	// 返回 amba port可用的port
	portnr = pl011_find_free_port();	
	...
	uap = devm_kzalloc(&dev->dev, sizeof(struct uart_amba_port),
			   GFP_KERNEL);
	...
	// 获取clock
	uap->clk = devm_clk_get(&dev->dev, NULL);
	...
	// 填充uap结构
	uap->reg_offset = vendor->reg_offset;	
	uap->vendor = vendor;					
	uap->fifosize = vendor->get_fifosize(dev);
	uap->port.iotype = vendor->access_32b ? UPIO_MEM32 : UPIO_MEM;
	uap->port.irq = dev->irq[0];	
	// 串口操作函数		
	uap->port.ops = &amba_pl011_pops;	
	...
	// 设置串口，对uap->port进行设置，并且将uap注册到amba_ports[]中
	ret = pl011_setup_port(&dev->dev, uap, &dev->res, portnr);
	...
	// 将串口注册到linux内核中，包括tty字符设备注册、终端注册、tty设备注册
	return pl011_register_port(uap);
}
```

### 2. 应用层使用
E2000D-demo板中串口的硬件接口对应软件上的节点分别为：
```
uart1：/dev/ttyAMA1
uart2：/dev/ttyAMA2
```
  a. 5线UART的使用（CPU调试口）
   
将开发板CPU_UART接口的TX、RX、GND引脚连接主机的串口适配器中的RXD、TXD、GND引脚，将串口适配器通过主机USB接口连接。开启开发板电源，打开主机的串口中断，将显示Linux系统的启动信息。

（1）查看UART1配置信息
```
~# stty -F /dev/ttyAMA1 -a
```

(2) 配置波特率
```
~# stty -F /dev/ttyAMA1 9600 		// 将波特率设置为9600
```
（3）发送数据
```
~# echo "cpu uart test ..." > /dev/ttyAMA1
cpu uart test ...
```
(4)接收数据
```
~# cat /dev/ttyAMA1 
cpu uart test ...			// 键入
cpu uart test ...			// 显示
```

b. 9线UART的使用

通过9线串口连接开发板与主机，启动开发板。相关操作与UART1相似，这里不再赘述。

c. 3线UART的使用

3线UART通过复用MIO接口实现，因此要使用3线UART，需要先配置MIO的复用：
```
# mw 0x28033000 0x1 1   	//mio15配置为uart
# mw 0x32B30248 0x46 1  	//配置N53管脚复用为mio15
# mw 0x32B3024C 0x46 1  	//配置J53管脚复用为mio15
```
此外，还需在设备树中添加解析mio15资源的节点：
```
mio15: uart@28032000 {
		compatible = "arm,pl011","arm,primecell";
		reg = <0x0 0x28032000 0x0 0x1000>;
		interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
		clocks = <&sysclk_50mhz &sysclk_50mhz>;
		clock-names = "uartclk","apb_pclk";
		status = "okay";
	};
```
确定mio15接口已经与主机连接，启动linux内核。成功进入系统后可以看到`/dev/`目录下新增文件`ttyAMA0`。然后可以对其进行相关的操作，见“5线UART的使用”。