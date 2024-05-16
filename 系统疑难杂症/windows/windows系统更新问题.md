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
   
   - 执行方案3：**Reset Windows update cache and delete the content in SoftwareDistribution**
   
     When any Windows update errors including 0xca020007 are generated, corruptions in cache and components are the prominent reasons. But you can clean the cache and repair the components without any problem if you implement the steps ahead –
     
     1. Access the elevated command prompt as you have done in Way-1.
     
     2. Run the following commands –
     
        ```bash
        net stop wuauserv
        net stop bits
        net stop cryptsvc
        ```
     
     3. Now open the File Explorer (Winkey+E).
     
     4. Copy the under-written path –
     
        ```bash
        C:\Windows\SoftwareDistribution\Download
        ```
     
     5. Paste this into the address bar and press **Enter**.
     
     6. Select all the content in the folder and delete them.
     
     7. Now run the below commands –
     
        ```bash
        net start wuauserv
        net start bits
        net start cryptsvc
        ```
     
     - Restart your computer and try getting the update.
     - In case, the update failed to install again then download this file – [Wureset_Windows_11_update.zip](https://www.howto-connect.com/wp-content/uploads/2022/09/Wureset_Windows_11.codzoc.zip).
     - Extract the zip package and browse the folder.
     - Right-click on **WuReset.bat** and select **Run as administrator**.
     - Click **Yes** on the UAC pop-up and press any key to start the reset command.
     - Exit the command prompt and try once more to receive the update.