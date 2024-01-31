## X100 LSD-GPIO 支持GPIO1控制器
### 问题描述
驱动未支持X100芯片的GPIO1控制器
### 解决方案
1. 两个GPIO控制器共64个中断，同时内核GPIO中断框架中支持的中断bit位最大为64，故可将控制器GPIO1的实现作为GPIO0的group，即将两个GPIO作为一个设备来处理；
2. 为兼容，新增变量`is_double_gpio_controller`来标识适配的GPIO控制器是单个还是两个；
3. 还需手动为GPIO1配置地址空间，GPIO1相较GPIO0偏移4K地址空间。

### 实施
已将解决方案整理为patch，复制该页面提供的**patch**到文件`0001-pci-gpio1.patch`中，使用方法：
1. 使用git打补丁
```
cd linux-kernel
vim 0001-pci-gpio1.patch   // 复制patch到该文件
git am 0001-pci-gpio1.patch
```

2. patch工具打补丁
```
cd linux-kernel
vim 0001-pci-gpio1.patch   // 复制patch到该文件
patch -p1 < 0001-pci-gpio1.patch
```
### patch
```c
From 20361517e01af1d6bfe1bfc2a3147e5aabbefbb7 Mon Sep 17 00:00:00 2001
From: zuoqian <zuoqian2032@phytium.com.cn>
Date: Fri, 19 May 2023 17:38:01 +0800
Subject: [PATCH] drivers: gpio: add support for second gpio controller in
 gpio-pci driver

---
 drivers/gpio/gpio-phytium-core.c | 166 ++++++++++++++++++++-----------
 drivers/gpio/gpio-phytium-core.h |   3 +
 drivers/gpio/gpio-phytium-pci.c  |   5 +
 3 files changed, 117 insertions(+), 57 deletions(-)

diff --git a/drivers/gpio/gpio-phytium-core.c b/drivers/gpio/gpio-phytium-core.c
index ea0bfb296..6cca836cf 100644
--- a/drivers/gpio/gpio-phytium-core.c
+++ b/drivers/gpio/gpio-phytium-core.c
@@ -63,8 +63,10 @@ int phytium_gpio_get(struct gpio_chip *gc, unsigned int offset)
 
 	if (get_pin_location(gpio, offset, &loc))
 		return -EINVAL;
-
-	dat = gpio->regs + GPIO_EXT_PORTA + (loc.port * GPIO_PORT_STRIDE);
+	if (gpio->is_double_gpio_controller && loc.port)
+		dat = gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_EXT_PORTA;
+	else
+		dat = gpio->regs + GPIO_EXT_PORTA + (loc.port * GPIO_PORT_STRIDE);
 
 	return !!(readl(dat) & BIT(loc.offset));
 }
@@ -80,7 +82,10 @@ void phytium_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
 
 	if (get_pin_location(gpio, offset, &loc))
 		return;
-	dr = gpio->regs + GPIO_SWPORTA_DR + (loc.port * GPIO_PORT_STRIDE);
+	if (gpio->is_double_gpio_controller && loc.port)
+		dr = gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_SWPORTA_DR;
+	else
+		dr = gpio->regs + GPIO_SWPORTA_DR + (loc.port * GPIO_PORT_STRIDE);
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
 
@@ -104,7 +109,10 @@ int phytium_gpio_direction_input(struct gpio_chip *gc, unsigned int offset)
 
 	if (get_pin_location(gpio, offset, &loc))
 		return -EINVAL;
-	ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
+	if (gpio->is_double_gpio_controller && loc.port)
+		ddr = gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_SWPORTA_DDR;
+	else
+		ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
 
@@ -126,7 +134,10 @@ int phytium_gpio_direction_output(struct gpio_chip *gc, unsigned int offset,
 
 	if (get_pin_location(gpio, offset, &loc))
 		return -EINVAL;
-	ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
+	if (gpio->is_double_gpio_controller && loc.port)
+		ddr = gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_SWPORTA_DDR;
+	else
+		ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
 
@@ -144,11 +155,13 @@ void phytium_gpio_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
-	u32 val = BIT(irqd_to_hwirq(d));
+	unsigned long val = BIT(irqd_to_hwirq(d));
 
 	raw_spin_lock(&gpio->lock);
-
-	writel(val, gpio->regs + GPIO_PORTA_EOI);
+	if (gpio->is_double_gpio_controller && (val >> 32))
+		writel(val >> 32, gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_PORTA_EOI);
+	else
+		writel(val & 0xffffffff, gpio->regs + GPIO_PORTA_EOI);
 
 	raw_spin_unlock(&gpio->lock);
 }
@@ -159,17 +172,22 @@ void phytium_gpio_irq_mask(struct irq_data *d)
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
 	u32 val;
+	unsigned long hwirq = irqd_to_hwirq(d);
 
 	/* Only port A can provide interrupt source */
-	if (irqd_to_hwirq(d) >= gpio->ngpio[0])
+	if (hwirq >= gpio->ngpio[0] && !gpio->is_double_gpio_controller)
 		return;
 
 	raw_spin_lock(&gpio->lock);
-
-	val = readl(gpio->regs + GPIO_INTMASK);
-	val |= BIT(irqd_to_hwirq(d));
-	writel(val, gpio->regs + GPIO_INTMASK);
-
+	if (hwirq >= gpio->ngpio[0] && gpio->is_double_gpio_controller) {
+		val = readl(gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTMASK);
+		val |= BIT(hwirq - gpio->ngpio[0]);
+		writel(val, gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTMASK);
+	} else {
+		val = readl(gpio->regs + GPIO_INTMASK);
+		val |= BIT(irqd_to_hwirq(d));
+		writel(val, gpio->regs + GPIO_INTMASK);
+	}
 	raw_spin_unlock(&gpio->lock);
 }
 EXPORT_SYMBOL_GPL(phytium_gpio_irq_mask);
@@ -179,17 +197,22 @@ void phytium_gpio_irq_unmask(struct irq_data *d)
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
 	u32 val;
+	unsigned long hwirq = irqd_to_hwirq(d);
 
 	/* Only port A can provide interrupt source */
-	if (irqd_to_hwirq(d) >= gpio->ngpio[0])
+	if (hwirq >= gpio->ngpio[0] && !gpio->is_double_gpio_controller)
 		return;
 
 	raw_spin_lock(&gpio->lock);
-
-	val = readl(gpio->regs + GPIO_INTMASK);
-	val &= ~BIT(irqd_to_hwirq(d));
-	writel(val, gpio->regs + GPIO_INTMASK);
-
+	if (hwirq >= gpio->ngpio[0] && gpio->is_double_gpio_controller) {
+		val = readl(gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTMASK);
+		val &= ~BIT(hwirq - gpio->ngpio[0]);
+		writel(val, gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTMASK);
+	} else {
+		val = readl(gpio->regs + GPIO_INTMASK);
+		val &= ~BIT(hwirq);
+		writel(val, gpio->regs + GPIO_INTMASK);
+	}
 	raw_spin_unlock(&gpio->lock);
 }
 EXPORT_SYMBOL_GPL(phytium_gpio_irq_unmask);
@@ -198,61 +221,65 @@ int phytium_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
-	int hwirq = irqd_to_hwirq(d);
-	unsigned long flags, lvl, pol;
+	unsigned long hwirq = irqd_to_hwirq(d);
+	unsigned long hwirq_tmp = hwirq;
+	unsigned long flags, lvl, pol, addr_offset = 0;
 
-	if (hwirq < 0 || hwirq >= gpio->ngpio[0])
+	if (hwirq < 0 || (hwirq >= gpio->ngpio[0] && !gpio->is_double_gpio_controller))
 		return -EINVAL;
 
 	if ((flow_type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) &&
 	    (flow_type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))) {
 		dev_err(gc->parent,
-			"trying to configure line %d for both level and edge detection, choose one!\n",
+			"trying to configure line %lu for both level and edge detection, choose one!\n",
 			hwirq);
 		return -EINVAL;
 	}
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
-
-	lvl = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
-	pol = readl(gpio->regs + GPIO_INT_POLARITY);
+	if (hwirq >= gpio->ngpio[0] && gpio->is_double_gpio_controller) {
+		addr_offset = GPIO_NEXT_ADDR_OFFSET;
+		hwirq_tmp = hwirq - gpio->ngpio[0];
+	}
+	lvl = readl(gpio->regs + addr_offset + GPIO_INTTYPE_LEVEL);
+	pol = readl(gpio->regs + addr_offset + GPIO_INT_POLARITY);
 
 	switch (flow_type) {
 	case IRQ_TYPE_EDGE_BOTH:
-		lvl |= BIT(hwirq);
+		lvl |= BIT(hwirq_tmp);
 		phytium_gpio_toggle_trigger(gpio, hwirq);
 		irq_set_handler_locked(d, handle_edge_irq);
-		dev_dbg(gc->parent, "line %d: IRQ on both edges\n", hwirq);
+		dev_dbg(gc->parent, "line %lu: IRQ on both edges\n", hwirq);
 		break;
 	case IRQ_TYPE_EDGE_RISING:
-		lvl |= BIT(hwirq);
-		pol |= BIT(hwirq);
+		lvl |= BIT(hwirq_tmp);
+		pol |= BIT(hwirq_tmp);
 		irq_set_handler_locked(d, handle_edge_irq);
-		dev_dbg(gc->parent, "line %d: IRQ on RISING edge\n", hwirq);
+		dev_dbg(gc->parent, "line %lu: IRQ on RISING edge\n", hwirq);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		lvl |= BIT(hwirq);
-		pol &= ~BIT(hwirq);
+		lvl |= BIT(hwirq_tmp);
+		pol &= ~BIT(hwirq_tmp);
 		irq_set_handler_locked(d, handle_edge_irq);
-		dev_dbg(gc->parent, "line %d: IRQ on FALLING edge\n", hwirq);
+		dev_dbg(gc->parent, "line %lu: IRQ on FALLING edge\n", hwirq);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		lvl &= ~BIT(hwirq);
-		pol |= BIT(hwirq);
+		lvl &= ~BIT(hwirq_tmp);
+		pol |= BIT(hwirq_tmp);
 		irq_set_handler_locked(d, handle_level_irq);
-		dev_dbg(gc->parent, "line %d: IRQ on HIGH level\n", hwirq);
+		dev_dbg(gc->parent, "line %lu: IRQ on HIGH level\n", hwirq);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		lvl &= ~BIT(hwirq);
-		pol &= ~BIT(hwirq);
+		lvl &= ~BIT(hwirq_tmp);
+		pol &= ~BIT(hwirq_tmp);
 		irq_set_handler_locked(d, handle_level_irq);
-		dev_dbg(gc->parent, "line %d: IRQ on LOW level\n", hwirq);
+		dev_dbg(gc->parent, "line %lu: IRQ on LOW level\n", hwirq);
 		break;
 	}
 
-	writel(lvl, gpio->regs + GPIO_INTTYPE_LEVEL);
+	writel(lvl, gpio->regs + addr_offset + GPIO_INTTYPE_LEVEL);
 	if (flow_type != IRQ_TYPE_EDGE_BOTH)
-		writel(pol, gpio->regs + GPIO_INT_POLARITY);
+		writel(pol, gpio->regs + addr_offset + GPIO_INT_POLARITY);
 
 	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 
@@ -266,17 +293,22 @@ void phytium_gpio_irq_enable(struct irq_data *d)
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
 	unsigned long flags;
 	u32 val;
+	unsigned long hwirq = irqd_to_hwirq(d);
 
 	/* Only port A can provide interrupt source */
-	if (irqd_to_hwirq(d) >= gpio->ngpio[0])
+	if (hwirq >= gpio->ngpio[0] && !gpio->is_double_gpio_controller)
 		return;
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
-
-	val = readl(gpio->regs + GPIO_INTEN);
-	val |= BIT(irqd_to_hwirq(d));
-	writel(val, gpio->regs + GPIO_INTEN);
-
+	if (hwirq >= gpio->ngpio[0] && gpio->is_double_gpio_controller) {
+		val = readl(gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTEN);
+		val |= BIT(hwirq - gpio->ngpio[0]);
+		writel(val, gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTEN);
+	} else {
+		val = readl(gpio->regs + GPIO_INTEN);
+		val |= BIT(hwirq);
+		writel(val, gpio->regs + GPIO_INTEN);
+	}
 	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 EXPORT_SYMBOL_GPL(phytium_gpio_irq_enable);
@@ -287,17 +319,22 @@ void phytium_gpio_irq_disable(struct irq_data *d)
 	struct phytium_gpio *gpio = gpiochip_get_data(gc);
 	unsigned long flags;
 	u32 val;
+	unsigned long hwirq = irqd_to_hwirq(d);
 
 	/* Only port A can provide interrupt source */
-	if (irqd_to_hwirq(d) >= gpio->ngpio[0])
+	if (hwirq >= gpio->ngpio[0] && !gpio->is_double_gpio_controller)
 		return;
 
 	raw_spin_lock_irqsave(&gpio->lock, flags);
-
-	val = readl(gpio->regs + GPIO_INTEN);
-	val &= ~BIT(irqd_to_hwirq(d));
-	writel(val, gpio->regs + GPIO_INTEN);
-
+	if (hwirq >= gpio->ngpio[0] && gpio->is_double_gpio_controller) {
+		val = readl(gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTEN);
+		val &= ~BIT(hwirq - gpio->ngpio[0]);
+		writel(val, gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTEN);
+	} else {
+		val = readl(gpio->regs + GPIO_INTEN);
+		val &= ~BIT(hwirq);
+		writel(val, gpio->regs + GPIO_INTEN);
+	}
 	raw_spin_unlock_irqrestore(&gpio->lock, flags);
 }
 EXPORT_SYMBOL_GPL(phytium_gpio_irq_disable);
@@ -311,7 +348,6 @@ void phytium_gpio_irq_handler(struct irq_desc *desc)
 	int offset;
 
 	chained_irq_enter(irqchip, desc);
-
 	pending = readl(gpio->regs + GPIO_INTSTATUS);
 	if (pending) {
 		for_each_set_bit(offset, &pending, gpio->ngpio[0]) {
@@ -325,6 +361,19 @@ void phytium_gpio_irq_handler(struct irq_desc *desc)
 		}
 	}
 
+	if (gpio->is_double_gpio_controller) {
+		pending = readl(gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_INTSTATUS);
+		if (pending) {
+			for_each_set_bit(offset, &pending, gpio->ngpio[0]) {
+				int irq = irq_find_mapping(gc->irq.domain,
+							offset + gpio->ngpio[0]);
+				generic_handle_irq(irq);
+				if ((irq_get_trigger_type(irq) &
+					IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
+					phytium_gpio_toggle_trigger(gpio, offset + gpio->ngpio[0]);
+			}
+		}
+	}
 	chained_irq_exit(irqchip, desc);
 }
 EXPORT_SYMBOL_GPL(phytium_gpio_irq_handler);
@@ -337,7 +386,10 @@ int phytium_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 
 	if (get_pin_location(gpio, offset, &loc))
 		return -EINVAL;
-	ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
+	if (gpio->is_double_gpio_controller && loc.port)
+		ddr = gpio->regs + GPIO_NEXT_ADDR_OFFSET + GPIO_SWPORTA_DDR;
+	else
+		ddr = gpio->regs + GPIO_SWPORTA_DDR + (loc.port * GPIO_PORT_STRIDE);
 
 	return !(readl(ddr) & BIT(loc.offset));
 }
diff --git a/drivers/gpio/gpio-phytium-core.h b/drivers/gpio/gpio-phytium-core.h
index a308a8aed..360b1437c 100644
--- a/drivers/gpio/gpio-phytium-core.h
+++ b/drivers/gpio/gpio-phytium-core.h
@@ -33,6 +33,8 @@
 #define NGPIO_MAX		32
 #define GPIO_PORT_STRIDE	(GPIO_EXT_PORTB - GPIO_EXT_PORTA)
 
+#define GPIO_NEXT_ADDR_OFFSET	0x1000
+
 struct pin_loc {
 	unsigned int port;
 	unsigned int offset;
@@ -67,6 +69,7 @@ struct phytium_gpio {
 #ifdef CONFIG_PM_SLEEP
 	struct phytium_gpio_ctx	ctx;
 #endif
+	int is_double_gpio_controller;
 };
 
 int phytium_gpio_get(struct gpio_chip *gc, unsigned int offset);
diff --git a/drivers/gpio/gpio-phytium-pci.c b/drivers/gpio/gpio-phytium-pci.c
index b1539c262..b7e8ac066 100644
--- a/drivers/gpio/gpio-phytium-pci.c
+++ b/drivers/gpio/gpio-phytium-pci.c
@@ -54,6 +54,11 @@ static int phytium_gpio_pci_probe(struct pci_dev *pdev, const struct pci_device_
 	/* There is only one group of Pins at the moment. */
 	gpio->ngpio[0] = NGPIO_MAX;
 
+	if (id->device == 0xdc31) {
+		gpio->is_double_gpio_controller = 1;
+		gpio->ngpio[1] = NGPIO_MAX;
+	}
+
 	/* irq_chip support */
 	gpio->irq_chip.name = dev_name(dev);
 	gpio->irq_chip.irq_ack = phytium_gpio_irq_ack;
-- 
2.25.1

```