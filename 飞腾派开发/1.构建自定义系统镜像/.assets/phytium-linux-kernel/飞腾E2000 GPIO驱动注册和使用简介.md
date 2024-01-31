## GPIO
GPIO为通用的输入输出接口，能够根据需求配置对应的引脚为输入输出，还可以用于连接各种外设或实现不同的数字功能。E2000集成6个GPIO控制器，提供96个GPIO信号。支持外部中断功能，每路中断没有优先级区分，并产生一个统一的中断送到全芯片的中断管理模块。支持中断的单独屏蔽和清除。其中GPIO0、GPIO1、GPIO2的每位中断单独上报，控制器GPIO3、GPIO4、GPIO5的中断由模块内合成一个中断上报。

### 1. GPIO驱动注册

GPIO驱动使用`module_platform_driver(phytium_gpio_driver)`注册驱动模块。若驱动与设备匹配成功，将通过结构体`phytium_gpio_driver`的probe函数来完成最后的驱动注册工作。代码主要位于`/kernel/drivers/gpio/gpio-phytium-platform.c`。

- 驱动文件中定义了gpio的`platform_driver`结构体`phytium_gpio_driver`，GPIO设备匹配有两种方式，一种是通过设备树匹配，一种是通过ACPI匹配，该内容介绍均以设备树匹配为例：
```c
static struct platform_driver phytium_gpio_driver = {
        .driver         = {
                .name   = "gpio-phytium-platform",
                ...
                .of_match_table = of_match_ptr(phytium_gpio_of_match),
                ...
        },
        .probe          = phytium_gpio_probe,
};

// 结构体数组phytium_gpio_of_match为设备驱动程序提供在设备树中的匹配机制
static const struct of_device_id phytium_gpio_of_match[] = {
        { .compatible = "phytium,gpio", },
        { }
};
```
- DTS中的`compatible`将与`.compatible`字符串匹配，匹配成功后，将执行相应的probe函数。
在e2000d-demo板中，GPIO的dts节点位于`kernel/arch/arm64/boot/dts/phytium/pe220x.dtsi`中，以gpio0为例：
```dts
gpio0: gpio@28034000 {
		compatible = "phytium,gpio";
		reg = <0x0 0x28034000 0x0 0x1000>;
		interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
					...
					<GIC_SPI 123 IRQ_TYPE_LEVEL_HIGH>;
		gpio-controller;
		#gpio-cells = <2>;
		#address-cells = <1>;
		#size-cells = <0>;
		status = "disabled";

		porta {
				compatible = "phytium,gpio-port";
				reg = <0>;
				ngpios = <16>;
		};
};
```
- `phytium_gpio_probe(struct platform_device *pdev)`将根据设备树信息对GPIO设备实例进行配置:

```c
static int phytium_gpio_probe(struct platform_device *pdev)
{
	...

	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
	...

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	gpio->regs = devm_ioremap_resource(&pdev->dev, res);
	...

	// 获取子节点中reg 和ngpios的数目
	device_for_each_child_node(dev, fwnode) {
		int idx;

		if (fwnode_property_read_u32(fwnode, "reg", &idx) ||
			idx >= MAX_NPORTS) {
			...
		}

		if (fwnode_property_read_u32(fwnode, "ngpios", &gpio->ngpio[idx]) &&
			fwnode_property_read_u32(fwnode, "nr-gpios", &gpio->ngpio[idx])) {
			...
		}
	}

	/* irq_chip support */
	gpio->irq_chip.name = dev_name(dev);
	gpio->irq_chip.irq_ack = phytium_gpio_irq_ack;
	...
	// 初始化gpio chip
	gpio->gc.base = -1;
	gpio->gc.get_direction = phytium_gpio_get_direction;
	...
	girq = &gpio->gc.irq;
	// 设置GPIO中断控制器的默认中断处理函数
	// 用于虚假中断或没有分配处理程序的中断等中断异常情况，以保证中断系统的稳定
	girq->handler = handle_bad_irq;
	// 设置默认中断类型为“未知”
	girq->default_type = IRQ_TYPE_NONE;
	// 从设备树中获取GPIO的硬件中断号，并存储在gpio->irq中
	for (irq_count = 0; irq_count < platform_irq_count(pdev); irq_count++) {
		gpio->irq[irq_count] = -ENXIO;
		gpio->irq[irq_count] = platform_get_irq(pdev, irq_count);
		if (gpio->irq[irq_count] < 0) {
				//dev_warn(dev, "no irq is found.\n");
				break;
		}
	};
	// 设置GPIO中断数量
	girq->num_parents = irq_count;
	// 将GPIO的中断设置为GPIO中断控制器的父中断，以便GPIO在处理中断时进行相关操作
	girq->parents = gpio->irq;
	// 设置GPIO中断的默认中断处理函数
	girq->parent_handler = phytium_gpio_irq_handler;

	girq->chip = &gpio->irq_chip;
	// 在GPIO子系统上注册GPIO控制器
	err = devm_gpiochip_add_data(dev, &gpio->gc, gpio);
	if (err)
			return err;
	// 设置pdev->dev->driver_date = gpio
	platform_set_drvdata(pdev, gpio);
	dev_info(dev, "Phytium GPIO controller @%pa registered\n",
			&res->start);

	return 0;
}
```

### 2. 应用层使用GPIO

#### 2.1. 命令行控制GPIO接口
1. 配置GPIO引脚复用

假定采用e2000d-demo板上引脚脚GPIO4_11和GPIO4_13，并短接。引脚复用的设置有两种方法：

（1）在uboot界面

```sh
mw.l 0x32B30148 0x246
mw.l 0x32B30150 0x246
```

（2）终端界面
```sh
sudo apt install devmem2                 // 安装devmem2读写寄存器
devmem2 0x32B30148 w 0x246
devmem2 0x32B30150 w 0x246
```
2. libgpio方式控制GPIO

从Linux4.8开始，推荐使用**libgpio**软件包，而以往通过sysfs的GPIO控制方式逐渐被淘汰。libgpio是linux内核提供的GPIO控制库，允许用户在用户空间控制GPIO引脚，包括设置引脚的方向（输入/输出）、读取引脚状态等。要使用libgpio，需要在系统中进行安装：

```sh
sudo apt install libgpiod-dev          // 安装开发库，其中包含GPIO控制代码头文件和开发工具
sudo apt install gpiod                 // 安装GPIO命令行工具
```

查看GPIO接口：
```sh
gpiodetect                      // 列举系统中的所有GPIO控制器
gpioinfo gpiochip4              // 查看gpiochip4控制器的引脚信息
```
配置/读取引脚方向：
```sh
gpioset gpiochip4 11=0          // 将引脚gpio4_11方向设置为0
gpioget gpiochip4 13            // 读取引脚gpio4_13引脚方向（为0）
gpioset gpiochip4 11=1          // 将引脚gpio4_11方向设置为1
gpioget gpiochip4 13            // 读取引脚gpio4_13引脚方向（为1）
```

监控GPIO引脚变化：
```sh
gpiomon gpiochip4 11 &          // 监控引脚gpio4_11状态
```
**GPIO引脚与gpiochip对应关系**：当设备树中描述并启用了所有的 GPIO 控制器时，libgpio 与硬件管脚一一对应。如果设备树中存在一个名为 gpiox 的控制器被禁用，那么 GPIO0 到 GPIO(x-1) 仍然与硬件对应，而 GPIO(x+1) 将与 gpiochipx 对应，以此类推。
```
~# gpiodetect 
gpiochip0 [28034000.gpio] (16 lines)
gpiochip1 [28035000.gpio] (16 lines)
gpiochip2 [28036000.gpio] (16 lines)
gpiochip3 [28037000.gpio] (16 lines)
gpiochip4 [28038000.gpio] (16 lines)
gpiochip5 [28039000.gpio] (16 lines)

~# find /sys/devices/ -name gpiochip* | sort  
/sys/devices/platform/soc/28034000.gpio/gpiochip0
/sys/devices/platform/soc/28035000.gpio/gpiochip1
/sys/devices/platform/soc/28036000.gpio/gpiochip2
/sys/devices/platform/soc/28037000.gpio/gpiochip3
/sys/devices/platform/soc/28038000.gpio/gpiochip4
/sys/devices/platform/soc/28039000.gpio/gpiochip5
```

3. sysfs接口控制GPIO(不推荐使用)

Linux4.8之前，最常见的控制GPIO的方式就是通过GPIO sysfs interface，它涉及对`/sys/class/gpio`目录下的文件执行操作，比如`export`、`unexport`、`gpiox/direction`、`gpiox/value`、`gpiox/edge`。

查看gpio接口：
```
~# ls /sys/class/gpio/
```

确定gpio接口与gpio控制器的对应关系：
```
~# ll /sys/class/gpio/
...
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip416 -> ../../devices/platform/soc/28039000.gpio/gpio/gpiochip416/
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip432 -> ../../devices/platform/soc/28038000.gpio/gpio/gpiochip432/
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip448 -> ../../devices/platform/soc/28037000.gpio/gpio/gpiochip448/
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip464 -> ../../devices/platform/soc/28036000.gpio/gpio/gpiochip464/
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip480 -> ../../devices/platform/soc/28035000.gpio/gpio/gpiochip480/
lrwxrwxrwx  1 root root    0 Mar 15  2023 gpiochip496 -> ../../devices/platform/soc/28034000.gpio/gpio/gpiochip496/
...
```
对于上述信息主要关注gpiochipx与gpio的soc下的文件名，同时查看gpio设备树的中的首地址：
```
gpio0: gpio@28034000 {
	...
}
gpio1: gpio@28035000 {
	...
}
gpio2: gpio@28036000 {
	...
}
gpio3: gpio@28037000 {
	...
}
gpio4: gpio@28038000 {
	...
}
gpio5: gpio@28039000 {
	...
}
```
由此可得到gpiochip与gpio设备的对应关系：
|  gpio   | gpiochip  |  address(0x)|
|  ----  | ----  | ----|
| gpio0 |  gpiochip496| 28034000
| gpio1  | gpiochip480 |28035000
| gpio2  | gpiochip464 |28036000
| gpio3  | gpiochip448 |28037000
| gpio4  | gpiochip432 |28038000
| gpio5  | gpiochip416 |28039000

每个gpio拥有16个引脚，在sysfs方式下，若要控制某个gpiochip(**gpiochip_base_number**)下的引脚，其引脚(**gpiochip_pin_number**)的计算方式为：`gpiochip_base_number+pin_number`。比如，如果要操作引脚gpio4_11，其对应的gpiochip_pin_number为：432+11=443，即gpiochip443。

导入GPIO接口：

```
echo 443 > /sys/class/gpio/export				//导入 gpio4_11
```

设置GPIO引脚方向：
```
echo out > /sys/class/gpio/gpio443/direction 
```

设置GPIO电平：
```
echo 0 > /sys/class/gpio/gpio443/value			// 设置为低电平
cat /sys/class/gpio/gpio443/value 
echo 1 > /sys/class/gpio/gpio443/value 			// 设置为高电平
cat /sys/class/gpio/gpio443/value 
```

设置中断触发方式：
```
echo in > /sys/class/gpio/gpio443/direction
echo both > /sys/class/gpio/gpio443/edge		// 任意方式触发中断
```

移除GPIO接口：
```
echo 443 > /sys/class/gpio/unexport		
```

#### 2.2. libgpio编程方式
gpiolib的头文件位于`/usr/include/gpiod.h`,它定义了用户访问GPIO的函数、结构和符号。根据调用其中的函数，可以完成对GPIO的控制。以下是一个简单的示例：
```c
#include <stdio.h>
#include <gpiod.h>
int main()
{
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int retflag = 0;
    // 获取gpio4控制器
    chip = gpiod_chip_open("/dev/gpiochip4");
    if (!chip) {
        printf("Failed to open chip");
        return -1;
    }

    // 获取gpio4_13引脚  
    line = gpiod_chip_get_line(chip, 13); 
    if (!line) {
        printf("Failed to get line");
        retflag = -1;
        goto chip_close;
    }
    // 将gpio4_13引脚设置为输出
    int ret = gpiod_line_request_output(line, "ExampleOutput", GPIOD_LINE_ACTIVE_STATE_LOW);
    if (ret < 0) {
        printf("Failed to request output");
        retflag = -1;
        goto line_release;
    }

    // 设置 GPIO 引脚状态为高电平
    ret = gpiod_line_set_value(line, 1);
    if (ret < 0) {
        printf("Failed to set value");
        retflag = -1;
        goto line_release;
    }

    // 读取 GPIO 引脚状态
    int value = gpiod_line_get_value(line);
    if (value < 0) {
        printf("Failed to get value");
        retflag = -1;
    }

line_release:
    gpiod_line_release(line);

chip_close:
    gpiod_chip_close(chip);

    return retflag;
}
```
