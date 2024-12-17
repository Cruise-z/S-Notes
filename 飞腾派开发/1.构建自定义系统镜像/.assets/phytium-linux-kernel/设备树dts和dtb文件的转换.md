#### dts和dtb的基本概念
dts(device tree source 设备树源文件)是Linux系统中对ARM设备中各个接口和组件的描述文件，遵循
dtb(device tree blob设备树二进制文件)是dts文件编译出来的二进制文件，与内核一同放入到存储介质中。当内核启动时读取设备树文件，就可以动态的将板级信息写入到内核中。

#### dts的编译工具dtc
在Ubuntu，Debian下安装
```shell
sudo apt-get install device-tree-compiler
```
或者在 **编译过** 的内核中，也可以找到dtc，在这里`scripts/dtc/dtc`。

#### dts编译成dtb
```shell
dtc -I dts -O dtb -o xxx.dtb xxx.dts
```

#### dtb反编译成dts
```shell
dtc -I dtb -O dts -o xxx.dts xxx.dtb
```

#### 内核中的设备树修改后的编译
内核中的设备树在`arch/arm64/boot/dts/phytium/` 下，dts文件中引用dtsi和.h。不能直接使用上面的dtc命令直接编译。 有三种做法可以使用。

##### A：在内核目录make
可以直接修改内核中的设备树文件，然后执行下面的命令
```shell
make dtbs
```

##### B：借助默认生成的dtb
编译内核时会生成默认的dtb文件，然后用dtc进行反编译成dts文件，修改完成后，再用dtc编译中dtb。

##### C：借助cpp
先修改内核中的设备树文件，然后在内核目录下执行
```shell
cpp -Wp,-MD,x.pre.tmp -nostdinc -I. -I include/  -undef -D__DTS__ -x assembler-with-cpp -o x.dts.tmp arch/arm64/boot/dts/phytium/xxx.dts
```

会得到x.dts.tmp文件，然后
```shell
dtc -I dts -O dts -i device-tree/ -o a.dts x.dts.tmp
```
得到a.dts后，就可以编译成dtb了
```shell
dtc -I dts -O dtb -o a.dtb a.dts
```