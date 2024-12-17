#### 问题
飞腾E2000 CPU支持两个DP口，不少客户会用转接芯片转成HDMI，但在系统启动时会出现如下error

```shell
[drm:phytium_gem_create_object] *ERROR* fail to allocate unified buffer with size a00000
或
[drm:phytium_gem_create_object [phytium_dc_drm]] *ERROR* fail to allocate unified buffer with size a00000
```

#### 原因

DP转HDMI后需要更多的连续内存，不加cma参数，或者设备树给dc预留内存，就会出现这种分配不出来的情况

#### 解决方法

##### cma参数

在内核启动时加入cma=256M,例如

```shell
setenv bootargs "console=ttyAMA1,115200 audit=0 earlycon=pl011,0x2800d000 root=/dev/sda3 rootdelay=5 rw cma=256M 
```

但有时发现cma的设置并没有解决问题，出现类似下面的信息
```shell
[    0.000000] Memory: 7664848K/8323072K available (7872K kernel code, 1448K rwdata, 3700K rodata, 512K init, 1328K bss, 658224K reserved,0K cma-reserved)
```
其实是cma没有在内核中使能，在内核中使能CONFIG_CMA就可以了。

##### 设备树预留内存

预留
```shell
 /dts-v1/;
 /memreserve/ 0x80000000 0x10000;
+/memreserve/ 0xf4000000 0x4000000;
```
 
和dc口关联
 
```shell
 &dc0 {
+        reg = <0x0 0x32000000 0x0 0x8000>,
+              <0x0 0xf4000000 0x0 0x4000000>; // (optional)
 	pipe_mask = [03];
 	edp_mask = [00];
 	status = "okay";
```