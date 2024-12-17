# 安装配置codeql



## 下载[[vscode-codeql-starter](https://github.com/github/vscode-codeql-starter)]

使用`git clone --recursive https://github.com/github/vscode-codeql-starter/`命令下载仓库
(递归下载子模块)

出现报错：

```shell
error: unable to create file csharp/ql/test/resources/stubs/runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl/4.3.0/runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl.csproj: Filename too long
```

> 参考issue：https://github.com/github/vscode-codeql-starter/issues/180解决：
> stack overflow链接：https://stackoverflow.com/questions/22575662/filename-too-long-in-git-for-windows
>
> > 附录 - 使用 PowerShell 完成所有操作 - 复制粘贴版
> > 这是 Windows 特有的问题，因此以下解决方案应该适用于大多数 Windows 版本（无论新旧）。
> > 打开 PowerShell 窗口/控制台，并运行以下命令：
> >
> > - 设置注册表值：
> >
> > ```shell
> > # Check LongPathsEnabled settings
> > Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled
> > 
> > # If 0, set it to 1 - This is a System wide configuration
> > # This will fail if you do not have Admin priveleges
> > # Changes to CurrentControlSet\Control take effect after a system restart
> > $MyPSexe = Get-Process -PID $PID | % Path
> > Start-Process -Verb RunAs $MyPSexe "-c","Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -Type DWord -Value 1"
> > ```
> >
> > - 设置`git config --system`——系统范围适用于所有 Windows 用户：
> >
> > ```shell
> > Start-Process -Verb RunAs "git" "config","--system","core.longpaths","true"
> > ```
> >
> > - 替代方案 - 非管理员选项：设置`git config --global`- 用户全局设置：
> >
> > ```shell
> > & git config "--global" core.longpaths true
> > ```

安装成功：![image-20241120142814403](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120142814403.png)

> **附件**：[使用指南](./安装配置codeql.assets/README.md)
>
> - 子模块更新：
>   Use `git submodule update --remote` regularly to keep the submodules up to date.
>
> - 为`git`设置代理：
>
>   ```shell
>   git config --global http.proxy http://127.0.0.1:17890
>   git config --global https.proxy http://127.0.0.1:17890
>   ```

## 安装并配置CodeQL引擎

### 本地

#### 下载

引擎二进制文件下载 ：[Releases · github/codeql-cli-binaries](https://github.com/github/codeql-cli-binaries/releases)

将其解压至`C:\Data\System\Compile_Environments\Code_Review`目录下：![image-20241120152056235](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120152056235.png)

#### 配置环境变量

并将`C:\Data\System\Compile_Environments\Code_Review\codeql-win64\codeql`该路径添加至环境变量中：![image-20241120152307870](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120152307870.png)

重启使环境变量生效并测试：![image-20241120152508493](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120152508493.png)

#### VScode配置

在`VScode`中安装`codeql`插件：![image-20241120154205523](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120154205523.png)

在`codeql`插件中配置`codeql`引擎的位置即可。

### 开发容器

#### 下载

[[vscode-codeql-starter](https://github.com/github/vscode-codeql-starter)]会提示建立`docker`以及下载并安装`codeql`；
其默认下载的`codeql`的位置位于`docker`镜像中的`/home/vscode/.vscode-server/data/User/globalStorage/github.vscode-codeql/distribution1/codeql`位置：![image-20241120213240978](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120213240978.png)

即使`vsc`下载失败，也可以自己手动下载然后将其放在`docker`容器中的一个位置然后`设置环境变量`、`在插件中配置`即可。

#### 配置环境变量

在`docker`的`~/.bashrc`中配置如下环境变量：（这里配置的是二进制文件`codeql`所在目录）![image-20241120213502986](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120213502986.png)

并使用`source ~/.bashrc`命令使环境变量生效即可。

#### VScode配置

在`codeql`插件中配置`docker`中`codeql`引擎的位置：（这里配置的是二进制文件`codeql`所在位置）![image-20241120213703178](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120213703178.png)



# codeql教程

## java工程示例

### 安装maven

执行如下命令即可：

```shell
sudo apt update
sudo apt install maven
```

### 建立数据库

以仓库`https://github.com/godzeo/java-sec-code`为例：

在`/workspaces/vscode-codeql-starter`路径新建`databases`文件夹存放工程仓库以及得到的数据库：![image-20241120235233249](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120235233249.png)

修改`workspace`文件，在其中添加这个文件夹：![image-20241127143402873](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241127143402873.png)

将仓库`clone`至该路径中，并运行如下命令：![image-20241120235357539](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120235357539.png)

```shell
codeql database create /workspaces/vscode-codeql-starter/databases/codeql_java-sec-code  --language="java"  --command="mvn clean install --file pom.xml" --source-root=/workspaces/vscode-codeql-starter/databases/java-sec-code
```

数据库建立成功后如下所示（时间略久）：![image-20241120235542671](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241120235542671.png)



## C工程示例

### 建立数据库

以仓库`https://github.com/hfiref0x/LightFTP`为例：

将仓库`clone`至`/workspaces/vscode-codeql-starter/databases`路径中，并运行如下命令：![image-20241126135007816](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126135007816.png)

```shell
codeql database create /workspaces/vscode-codeql-starter/databases/codeql_LightFTP  --language="cpp"  --command="make" --source-root=/workspaces/vscode-codeql-starter/databases/LightFTP/Source/Release
```

数据库建立成功后如下所示（时间略久）：![image-20241126135330830](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126135330830.png)

### 导入并查询

在`vscode`里面点击`QL`并找到从文件夹导入数据库：![image-20241126135625243](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126135625243.png)

在`/workspaces/vscode-codeql-starter/ql/cpp/ql/src/Security/CWE/`文件夹中找到想要查询的`CWE`编号对应的漏洞：

#### CWE-089: sql-injection

这里选择漏洞`CWE-089`进行查询：![image-20241126140318341](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126140318341.png)

然后右键点击`CodeQL: Run Query on Selected Database`即可：![image-20241126140434808](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126140434808.png)

然后得到查询结果：![image-20241126140621084](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126140621084.png)

对于这个漏洞没有找到相关的危险代码，那我们换个漏洞试试；

#### CWE-119: overflow-buffer

查询结果如下：![image-20241126141641041](./%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEcodeql.assets/image-20241126141641041.png)

还是没有。。。

#### CWE-416: UAF

查询结果如下：
