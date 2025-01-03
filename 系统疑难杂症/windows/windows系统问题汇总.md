# windows系统问题汇总

## 更新问题

### windows更新失败提示`下载错误:0xca020007`：

> 参考：https://www.howto-connect.com/fix-update-error-0xca020007-windows-11-or-10-solved/
>

- 执行方案1：

  ```bash
  DISM /Online /Cleanup-Image /CheckHealth
  DISM /Online /Cleanup-Image /ScanHealth
  DISM /Online /Cleanup-Image /RestoreHealth
  ```

  - 在执行下面的第三条命令时卡住：

    解决办法：

    > 参考：https://www.bilibili.com/read/cv23572864/

    - 卡住半个小时左右很正常，先耐心等待即可！！！

    - 进度实在是不动了就关机重启；

    - 依次执行下面的命令：

      ```bash
      dism /online /cleanup-image /restorehealth 
      sfc /scannow 
      DISM /Online /Cleanup-Image /StartComponentCleanup
      DISM /Online /Cleanup-Image /RestoreHealth /Source:C:\RepairSource\Windows /LimitAccess
      ```

  - 方案1执行完后重启并未解决该更新问题：

    说明更新问题与此问题无关。。。
    
    在联想电脑管家的工具箱中关闭**锁屏壁纸功能**即可解决这个问题：
    
    > 参考：https://www.bilibili.com/read/cv23572864/#:~:text=%E6%9C%97%E5%B7%9E%E5%8F%B8%E9%A9%AC,%E6%8A%8A%E5%A3%81%E7%BA%B8%E5%85%B3%E6%8E%89
    >
    > ==**注：**==联想锁屏功能现转移至：`联想应用商店` $\rightarrow$ `设置中心` $\rightarrow$ `壁纸设置处`
    
    ![image-20240517173739662](./windows%E7%B3%BB%E7%BB%9F%E9%97%AE%E9%A2%98%E6%B1%87%E6%80%BB.assets/image-20240517173739662.png)<img src="./windows%E7%B3%BB%E7%BB%9F%E9%97%AE%E9%A2%98%E6%B1%87%E6%80%BB.assets/image-20240926155010551.png" alt="image-20240926155010551"  />

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

## 网络问题

### Windows 11设置让外部访问优先使用无线/有线网络？

> 参考：
>
> - https://www.zhihu.com/question/546676895/answer/3287261638
> - https://www.bilibili.com/read/cv33491047/?jump_opus=1

我使用的是第二种方法：

- 控制面版->网络和internet->更改适配器设置->里面有不同的各个链接，假设有WIFI和有线连接这两个，
- 分别进入属性，IPv4/v6协议->高级->自动跃点,接口跃点数，点数越小优先级越大，一般优先的设置成120-150之间，不优先的设置成250左右。
- 然后系统就会自动选择优先级大的网络连接进行连网。