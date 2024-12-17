# `Ubuntu`配置`Anaconda`

> 参考：https://blog.csdn.net/qq_64671439/article/details/135293643

## `Anaconda`安装教程

### 下载`Anaconda`安装包

官方下载地址：[Free Download | Anaconda](https://www.anaconda.com/download/)

打开后点击`Download`即可自动检测你当前的系统，下载对应`linux`版本的`Anaconda`。
也可以点击下方的小企鹅，下载对应的`Anaconda`

### 安装`Anaconda`

进入下载目录运行`bash ./Anaconda3-xxxx.xx-x-Linux-x86_64.sh`即可

> 注意：安装时会遇到一大堆很长的条款，使用`PgDn`键可快进至选择/输入

### 安装后提示

- For changes to take effect, close and re-open your current shell.

  > 意思是：关闭当前命令行，并重新打开，刚刚安装和初始化 Anaconda 设置才可以生效，重新打开一个命令行后直接就进入了 `conda` 的 `base` 环境，如下（命令行前面多了`base`）：

  ![image-20241016145920011](./anaconda_Ubuntu.assets/image-20241016145920011.png)

- If you'd prefer that conda's base environment not be activated on startup, set the auto_activate_base parameter to false:

  > 意思是：如果您希望`conda`的基础环境在启动时不被激活，请将`auto_activate_base`参数设置为`false`，命令如下：
  >
  > ```shell
  > conda config --set auto_activate_base false
  > ```
  >
  > 当然这一条命令执行完毕后，想要再次进入`conda`的`base`环境，只需要使用对应的`conda`指令即可，如下：
  >
  > ```shell
  > conda activate base
  > ```

## `conda`使用指南

### 创建与删除环境

#### 创建新环境

```shell
conda create -n your_env_name python=x.x
```

#### 删除已有环境

```shell
conda remove -n your_env_name --all
```

