# tmux使用方法

## 如何设置`tmux`构建的窗口名？

在 `tmux` 中设置窗口的名称可以通过两种方式：

### 1. 在创建窗口时设置名称

在创建新窗口时，你可以通过 `-n` 选项来设置窗口的名称。例如：

```bash
tmux new-window -n "my_window_name"
```

这将创建一个新的 `tmux` 窗口，并将其命名为 `my_window_name`。

### 2. 在已经打开的 `tmux` 窗口中修改名称

如果你想修改当前窗口的名称，可以使用 `rename-window` 命令。你可以在 `tmux` 会话中按下 `Ctrl + b`，然后按下 `,`（逗号），然后输入新的窗口名称。

或者，你也可以直接在命令行中使用 `rename-window` 来修改当前窗口的名称：

```bash
tmux rename-window "new_window_name"
```

### 总结

- **创建窗口时设置名称**：`tmux new-window -n "my_window_name"`
- **修改当前窗口名称**：`tmux rename-window "new_window_name"`

这样你就能轻松地设置和修改 `tmux` 窗口的名称了！



## 如何指定重连`tmux`的窗口？

要连接到 `tmux` 会话中的指定窗口，可以使用以下几种方法：

### 方法 1: 使用 `tmux attach-session` 命令

如果你已经处于一个 `tmux` 会话中，但想要连接到其他会话或窗口，你可以使用 `attach-session` 命令。若你已经在 `tmux` 会话中并且想连接到一个特定窗口，可以按以下步骤：

1. **列出当前会话和窗口信息**：

   ```bash
   tmux list-sessions
   ```

   输出示例如下：

   ```
   0: 1 windows (created Wed Aug 18 11:17:29 2025) [144x43] (attached)
   1: 2 windows (created Wed Aug 18 11:18:33 2025) [144x43]
   ```

2. **连接到指定会话**：
    假设你想连接到会话编号 `1`，你可以使用以下命令：

   ```bash
   tmux attach-session -t 1
   ```

   如果你在一个会话中并想切换到另一个会话，这个命令将允许你连接到指定的会话。

### 方法 2: 使用 `tmux switch-window` 切换到指定窗口

如果你已经连接到一个 `tmux` 会话并想切换到该会话中的某个窗口，你可以使用 `switch-window` 命令：

1. **列出所有窗口信息**：

   ```bash
   tmux list-windows
   ```

2. **切换到指定窗口**：
    假设你想切换到窗口编号 `1`，可以使用以下命令：

   ```bash
   tmux select-window -t 1
   ```

   这会让你从当前窗口切换到窗口 `1`。

### 方法 3: 使用快捷键切换窗口

在 `tmux` 会话中，你还可以使用快捷键快速切换窗口：

1. 按下 `Ctrl + b`，然后按数字键（`0` 到 `9`）来切换到指定的窗口。例如，按 `Ctrl + b` 后按 `1`，即可切换到窗口 `1`。

### 方法 4: 使用 `tmux attach` 恢复窗口

如果你想恢复一个已经断开的会话，可以直接使用 `tmux attach` 命令：

```bash
tmux attach -t <session-name>
```

这会连接到指定的会话（如果该会话已存在并且是分离状态）。

### 总结：

- `tmux attach-session -t <session-name>`：连接到指定的会话。
- `tmux select-window -t <window-index>`：切换到指定的窗口。
- `Ctrl + b` 后按窗口的数字键：快速切换窗口。
