# Ubuntu+安全启动+MOK=驱动更新卡死

> 参考：https://forums.linuxmint.com/viewtopic.php?t=396162

更新nvidia显卡驱动并重启后，由于开启了安全启动且内核模块的MOK签名被更改，导致系统卡死。。。

解决方法如下：

- 重启Ubuntu并安装新的显卡驱动

- 开启命令行，重置MOK密钥：

  ```shell
  sudo mokutil --reset
  ```

- 重启系统，出现蓝屏，选择：`continue reboot`

- 然后对之前使用MOK签名的内核模块重新签名。。。
