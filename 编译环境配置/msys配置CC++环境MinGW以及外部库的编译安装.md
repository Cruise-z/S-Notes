# msys2配置C/C++环境MinGW以及外部库的编译安装



## 安装msys2：

**网站链接**：https://www.msys2.org/



## 在msys2中配置MinGW32/64：

打开`ucrt64.exe`应用程序，输入如下命令：

1. **更新包数据库和系统**： 首先确保 MSYS2 的软件包数据库和现有安装的包是最新的。

   ```bash
   pacman -Syu
   pacman -Su
   ```

   运行完该命令后，建议关闭并重新打开 MSYS2 终端。

2. **安装完整的 `mingw-w64-x86_64` 工具链**： 使用以下命令安装 `mingw-w64-x86_64` 工具链的所有必要组件：

   ```bash
   pacman -S mingw-w64-x86_64-toolchain
   ```

   该命令将安装以下主要组件：

   - `gcc`: C/C++ 编译器
   - `gdb`: 调试器
   - `binutils`: 二进制工具（如链接器、汇编器等）
   - `make`: 构建工具
   - `libwinpthread`: Windows 线程库

3. **选择其他常用工具和库**： 如果你需要安装其他工具或库（如 `clang`、`cmake`、`python`、开发库等），可以单独安装。例如：

   - 安装 `clang` 编译器：

     ```bash
     pacman -S mingw-w64-x86_64-clang
     ```

   - 安装 `cmake`：

     ```bash
     pacman -S mingw-w64-x86_64-cmake
     ```

   - 安装 `python`：

     ```bash
     pacman -S mingw-w64-x86_64-python
     pacman -S mingw-w64-x86_64-python3
     ```

   - 管理共享库：

     ```bash
     pacman -S mingw-w64-x86_64-libtool
     ```

   - 自动化配置工具：

     ```bash
     pacman -S autoconf
     ```

   - 生成 `Makefile` 的工具：

     ```bash
     pacman -S automake
     ```

4. **检查已安装的组件**： 你可以使用以下命令检查是否已安装某些包：

   ```bash
   pacman -Qs mingw-w64-x86_64
   ```

   通过上述步骤，你可以安装和配置完整的 `mingw-w64-x86_64` 开发环境。如果需要更多特定的库或工具，可以根据项目需求使用 `pacman` 安装相应的包。



## 编译安装外部库：以gmp库为例

### 安装外部库

#### 去官网下载安装

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

#### 直接安装

如果确实没有安装 `gmp`，你可以通过以下命令来安装 64 位版本的 `gmp`：

```bash
pacman -S mingw-w64-x86_64-gmp
```

对于 32 位环境，使用：

```bash
pacman -S mingw-w64-i686-gmp
```



### 删除外部库

在 MSYS2 的 MinGW 环境中，你可以通过 `pacman` 命令来查看已安装的外部库版本以及卸载库。以下是具体步骤：

**以gmp大数库为例：**

#### 1. 查看库的当前版本

要查看已安装的 GMP（GNU Multiple Precision Arithmetic Library）库的版本，你可以使用以下命令：

```bash
pacman -Qi mingw-w64-x86_64-gmp
```

该命令会显示 `mingw-w64-x86_64-gmp` 包的详细信息，包括版本号、安装日期、依赖关系等。如果你使用的是 32 位环境，请将命令中的 `x86_64` 替换为 `i686`。

#### 2. 卸载库

如果你想卸载 GMP 库，可以使用以下命令：

```bash
pacman -Rns mingw-w64-x86_64-gmp
```

这个命令会：
- **`-R`**：删除指定的包。
- **`-n`**：删除包及其配置文件。
- **`-s`**：同时删除不再被其他包依赖的依赖项。

如果你使用的是 32 位环境，命令如下：

```bash
pacman -Rns mingw-w64-i686-gmp
```

#### 3. 查看已安装的所有库

如果你想查看 MinGW 环境中安装的所有库，可以使用以下命令：

```bash
pacman -Qe
```

这会列出所有通过 `pacman` 安装的外部库及工具，通过这些命令，你可以轻松查看和管理 GMP 库在 MSYS2 中的安装状态。

> 如果你在 MSYS2 中使用 `pacman -Qe` 没有看到 `gmp` 大数库，这可能意味着 `gmp` 库并没有安装，或者它是作为依赖项而非显式安装的。
>
> 要确认是否已安装 `gmp`，你可以使用以下命令来检查 **所有已安装的包**，而不仅仅是显式安装的包：
>
> ```bash
> pacman -Qs gmp
> ```
>
> 这将列出所有与 `gmp` 相关的包，包括那些作为依赖项安装的包。如果 `gmp` 已安装，你会在结果中看到类似 `mingw-w64-x86_64-gmp` 或 `mingw-w64-i686-gmp` 的条目。
>



## 注：

MSYS2 提供了多个不同的环境（Shell），其中包括 `msys2.exe` 和 `ucrt64.exe`，它们的主要区别在于它们使用的工具链和目标平台。具体来说：

### 1. **`msys2.exe`**
   - **功能**: 提供一个类 Unix 的环境，用于运行 POSIX 工具和软件，类似于 Cygwin。这是 MSYS2 的基础环境，通常用于编写和执行脚本、安装软件包、以及构建 Windows 下的开源项目。
   - **目标**: `msys2.exe` 更侧重于提供一个开发工具集，帮助 Windows 用户使用 Linux 风格的工具（如 `bash`、`grep`、`sed` 等）来开发软件。
   - **使用场景**: 
     - 适合执行 POSIX 兼容的脚本和工具。
     - 不太适合用于编译原生 Windows 应用程序，而是为了在 Windows 下运行 Unix 风格的程序和工具。

   通常，你会使用它来运行 shell 脚本，或者进行一些跨平台的开发工作，主要用于构建和运行基于 POSIX 的工具。

### 2. **`ucrt64.exe`**
   - **功能**: 提供一个基于 `MinGW-w64 UCRT`（Universal C Runtime）的 64 位工具链。这个环境针对 Windows 平台编译原生 64 位应用程序，使用的是微软的 Universal C Runtime (UCRT) 作为 C 标准库。
   - **目标**: 用于编译和构建原生的 64 位 Windows 应用程序，它依赖于 Windows 自带的 `ucrtbase.dll`。
   - **使用场景**: 
     - 适合使用 `gcc` 或 `clang` 等编译器编译原生的 Windows 程序。
     - 如果你想开发与 Windows UCRT 兼容的 64 位应用程序，`ucrt64.exe` 是更好的选择。

   `ucrt64` 环境提供的工具链（例如 `gcc`、`g++` 等）会默认使用 UCRT 作为运行时库，而不是传统的 MSVCRT 或其他实现。它更适合用于构建与 Windows 系统紧密集成的应用。

### 总结
- **`msys2.exe`**: 主要用于提供类似 Unix 的环境，运行 POSIX 工具，更多是跨平台开发和工具支持，不适合编译原生 Windows 程序。
- **`ucrt64.exe`**: 针对原生 64 位 Windows 开发，使用的是 MinGW-w64 UCRT 工具链，适合开发和编译依赖 Windows UCRT 的程序。

选择哪一个取决于你的开发需求。如果你主要是进行 POSIX 风格的开发或者运行工具，使用 `msys2.exe`；如果你是要编译 Windows 原生应用程序，特别是依赖 UCRT 的程序，`ucrt64.exe` 更合适。
