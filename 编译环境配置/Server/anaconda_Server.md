# `Ubuntu`配置`Anaconda`

> 参考：https://blog.csdn.net/qq_64671439/article/details/135293643

## `Anaconda`安装教程

在服务器上安装 **Conda** 并构建虚拟环境的步骤如下：

### 1. **安装 Conda（使用 Miniconda 或 Anaconda）**

#### **Miniconda**（推荐，因为它更轻量）

Miniconda 是一个轻量级的 Conda 安装包，包含 Conda 和一些必要的包，而不像 Anaconda 那样包括大量的科学计算库。

##### 步骤：

1. **下载 Miniconda 安装包**

   根据你服务器的操作系统选择适合的 Miniconda 版本：

   - **Linux**: [Miniconda3 Linux 64-bit](https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh)
   - **Windows**: [Miniconda3 Windows 64-bit](https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe)
   - **macOS**: [Miniconda3 macOS 64-bit](https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh)

   你可以使用 `wget` 命令来下载 Miniconda 安装脚本（假设服务器上有 Linux）：

   ```bash
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   ```

2. **安装 Miniconda**

   运行下载的安装脚本：

   ```bash
   bash Miniconda3-latest-Linux-x86_64.sh
   ```

   按照提示进行安装，通常选择默认选项。安装完成后，它会提示是否初始化 Miniconda，将 Miniconda 添加到你的环境变量中，选择 `yes`。

3. **初始化 Conda 环境**

   安装完成后，执行：

   ```bash
   source ~/.bashrc
   ```

   这样 Conda 就会被添加到你的环境变量中，允许你在命令行中使用 `conda` 命令。

#### **Anaconda**（如果你需要完整的 Python 数据科学包）

如果你更倾向于安装 **Anaconda**（包含更多预装的库，如 NumPy、Pandas、Matplotlib 等），你可以使用类似的步骤，只是下载和安装 Anaconda。

下载并安装 Anaconda：

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2025.07-Linux-x86_64.sh
bash Anaconda3-2025.07-Linux-x86_64.sh
```

将conda添加到shell配置文件中：

> 1. **执行 `conda` 初始化命令**
>
>    你可以手动初始化 Conda，以确保它能在你的 shell 会话中正确运行。
>
>    根据你当前使用的 shell（假设是 Bash），运行以下命令：
>
>    ```bash
>    eval "$(/home/zhaorz/anaconda3/bin/conda shell.bash hook)"
>    ```
>
>    这将会激活 Conda 环境，使你可以在当前 shell 会话中使用 `conda` 命令。
>
> 2. **将 `conda init` 添加到 shell 配置文件中**
>
>    为了让 Conda 在每次启动新的 shell 时都能自动配置，你需要将 `conda init` 添加到你的 shell 配置文件中。运行以下命令：
>
>    ```bash
>    conda init
>    ```
>
>    如果你没有通过 `conda init` 自动修改配置文件，你也可以手动将 `conda` 初始化脚本添加到配置文件中。以 Bash 为例，编辑 `~/.bashrc` 文件：
>
>    ```bash
>    nano ~/.bashrc
>    ```
>
>    在文件的末尾添加以下内容：
>
>    ```bash
>    # Add Conda to shell environment
>    eval "$(/home/zhaorz/anaconda3/bin/conda shell.bash hook)"
>    ```
>
>    保存文件并退出后，执行以下命令使更改生效：
>
>    ```bash
>    source ~/.bashrc
>    ```
>
> 3. **验证 Conda 是否正确安装**
>
>    在执行完上述步骤后，重新启动一个新的终端会话，或者在当前会话中执行以下命令来验证 Conda 是否正常工作：
>
>    ```bash
>    conda --version
>    ```
>
>    如果安装成功，你应该能看到 Conda 的版本信息，例如：
>
>    ```bash
>    conda 23.1.0
>    ```
>
> 4. **检查环境变量**
>
>    如果依然无法使用 `conda` 命令，请确认 `conda` 可执行文件的路径是否在你的 `PATH` 环境变量中。你可以通过以下命令检查：
>
>    ```bash
>    echo $PATH
>    ```
>
>    其中应包括 `/home/zhaorz/anaconda3/bin` 目录。如果没有包含该路径，你可以手动添加：
>
>    ```bash
>    export PATH="/home/zhaorz/anaconda3/bin:$PATH"
>    ```
>
>    你可以将此命令添加到 `~/.bashrc` 或 `~/.bash_profile` 中，以便每次启动终端时都会生效。
>
> ------
>
> 完成以上步骤后，`conda` 命令应该可以正常使用了。如果还有问题，欢迎继续提问！

### 2. **创建 Conda 虚拟环境**

1. **更新 Conda**

   安装完 Conda 后，首先更新 Conda 到最新版本：

   ```bash
   conda update conda
   ```

2. **创建一个新的虚拟环境**

   使用 `conda create` 命令来创建一个新的虚拟环境。假设你要创建一个名为 `myenv` 的虚拟环境，并指定 Python 版本（例如，Python 3.8）：

   ```bash
   conda create --name myenv python=3.8
   ```

   你可以根据需要指定其他包和版本。例如，创建一个包含 NumPy 和 Pandas 的虚拟环境：

   ```bash
   conda create --name myenv python=3.8 numpy pandas
   ```

3. **激活虚拟环境**

   创建环境后，使用以下命令激活它：

   ```bash
   conda activate myenv
   ```

4. **安装其他包**

   如果你需要在虚拟环境中安装其他包，可以使用 `conda install` 命令。例如，安装 `matplotlib`：

   ```bash
   conda install matplotlib
   ```

5. **查看已安装的环境**

   你可以查看所有 Conda 环境：

   ```bash
   conda env list
   ```

   或者使用：

   ```bash
   conda info --envs
   ```

6. **退出虚拟环境**

   要退出当前虚拟环境，使用：

   ```bash
   conda deactivate
   ```

### 3. **管理 Conda 虚拟环境**

- **删除虚拟环境**

  如果不再需要某个虚拟环境，可以使用以下命令删除它：

  ```bash
  conda remove --name myenv --all
  ```

- **查看已安装的包**

  要查看当前虚拟环境中安装的所有包，可以使用：

  ```bash
  conda list
  ```

### 总结

- **Miniconda** 是一个轻量级的 Conda 发行版，适合需要自定义包安装的用户。
- **Anaconda** 包含了大量常用的科学计算库，适合需要快速开始数据分析、机器学习的用户。
- 创建和管理虚拟环境非常简单，通过 `conda create` 和 `conda activate` 可以很方便地为不同的项目创建隔离的 Python 环境。

如果你有其他需求，或者在安装和使用中遇到问题，可以随时问我！

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

