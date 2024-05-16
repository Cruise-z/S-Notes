# windows系统更新问题

1. windows更新失败提示`下载错误:0xca020007`：

   > 参考：https://www.howto-connect.com/fix-update-error-0xca020007-windows-11-or-10-solved/
   >
   
   - 执行方案1：
   
     在执行下面的第三条命令时卡住：
   
     ```bash
     DISM /Online /Cleanup-Image /CheckHealth
     DISM /Online /Cleanup-Image /ScanHealth
     DISM /Online /Cleanup-Image /RestoreHealth
     ```
   
     解决办法：关闭联想电脑管家即可顺利执行。
   
     方案1执行完后重启并未解决问题。。。
   
   - 执行方案3：
   
     顺利解决。