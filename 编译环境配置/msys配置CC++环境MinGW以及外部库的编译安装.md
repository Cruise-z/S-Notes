# msys2配置C/C++环境MinGW以及外部库的编译安装



## 安装msys2：

**网站链接**：https://www.msys2.org/



## 在msys2中配置MinGW32/64：

1. 打开UCRT应用程序：输入如下命令行

   ```bash
   pacman -Syu
   pacman -Su
   //安装下述包
   pacman -S mingw-w64-x86_64-gcc
   pacman -S mingw-w64-x86_64-make
   pacman -S mingw-w64-x86_64-libtool
   pacman -S autoconf
   pacman -S automake
   pacman -S mingw-w64-x86_64-python3
   ```



## 编译安装外部库：以gmp库为例

1. 下载最新版本的gmp大数库：

   **网站链接**：https://gmplib.org/

2. 打开`./msys64/mingw64.exe`

3. 将当前工作目录切换为gmp大数库的下载位置：

   - 将`./msys64/mingw64/bin`目录下的`mingw32-make.exe`重命名为`make.exe`

   - 执行如下命令：
   
     ```bash
     ./configure --enable-cxx 
     make -j12
     make check
     make install
     ```
   
     等一段时间即可完成。
   
   - ==将第一步的`make.exe`换回原来的名字==，防止在使用该gcc环境时编译失败(这是因为经编译得到的.dll或是.exe中的调用名无法改变)



