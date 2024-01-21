# PWM模块



> **参考：**
>
> -    [CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf](.assets/CEK8903萤火工场·飞腾派软件开发手册-V1.0.pdf) 
> -    [CEK8902原理图_v3_sch.pdf](.assets/CEK8902原理图_v3_sch.pdf) 



## 一、前置知识：

> PWM（脉冲宽度调制）模块是一种电子设备中常见的控制模块，用于生成脉冲信号，通过调整脉冲的宽度来控制电路中的电流或电压。PWM通常用于控制电机的速度、调节LED的亮度、实现类比信号的数字化等应用。
>
> 以下是关于PWM模块的一些基本信息：
>
> 1. **工作原理：** PWM通过周期性地改变信号的脉冲宽度来控制输出电压的平均值。通常，PWM信号的周期是固定的，而脉冲的宽度（占空比）是可调的。通过改变占空比，可以改变输出电压的大小。
> 2. **应用领域：** PWM广泛用于电子设备中，特别是在嵌入式系统和电路中。常见的应用包括电机控制、LED调光、电源调节等。
> 3. **电机控制：** 在电机控制中，PWM信号用于调节电机的转速。通过改变PWM信号的占空比，可以改变电机的平均电压，从而实现对电机速度的精确控制。
> 4. **LED调光：** 在照明应用中，PWM信号用于调节LED的亮度。通过改变PWM信号的占空比，可以实现LED的平滑调光，而不会引起明显的闪烁。
> 5. **电源调节：** PWM也可用于电源电压的调节。通过调整PWM信号的占空比，可以实现对输出电压的调整，用于稳定化电源输出。
> 6. **嵌入式系统：** 在嵌入式系统中，微控制器或微处理器通常提供PWM模块，使开发者能够轻松地实现各种控制任务。
> 7. **硬件实现：** PWM可以通过硬件电路实现，也可以通过软件在数字信号处理器（DSP）或微控制器中模拟实现。
> 8. **调制频率：** PWM信号的调制频率是指脉冲信号的周期，通常以赫兹（Hz）为单位。调制频率的选择取决于具体的应用需求。
>
> 总体而言，PWM模块是一种强大的控制工具，广泛用于电子系统中的各种应用，提供了灵活的电压和电流控制手段。



## 二、实施细节：

- 使用一个LED灯利用PWM模块实现实现呼吸灯控制，选取PWM2引脚(GPIO1_1引脚)及一根接地引脚：![image-20240121193048362](./PWM%E6%A8%A1%E5%9D%97.assets/image-20240121193048362.png)![image-20240121193215861](./PWM%E6%A8%A1%E5%9D%97.assets/image-20240121193215861.png)

- 利用飞腾开发板的PWM模块：![image-20240121193551713](./PWM%E6%A8%A1%E5%9D%97.assets/image-20240121193551713.png)

  通过调整一个周期内的高电平时间使得LED灯的亮度发生周期性变化。

- 编写C脚本，编译生成.o文件执行：

  脚本如下：

  ```c
  /*
  本案例实现呼吸灯效果，使用到的引脚为PWM2(GPIO1_1)，将这个引脚设置为输出，LED负极接地。
   */
  //涉及到设备操作的,需包含以下头文件
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  
  //包含close/read/write/lseek等函数
  #include <unistd.h>
  
  //包含printf/sprintf函数
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  
  #define LED1_PIN 0 //PWM2_0 = 2+0
  #define LED2_PIN 492 //GPIO1_12 = 480+12
  #define LED3_PIN 491 //GPIO1_11 = 480+11
  
  
  #define PWM_PATH "/sys/class/pwm/pwmchip2/"
  
  int setargs(int *led_table, int led_pos, char *args, char *input);
  
  int main(void){
  
      int led_table[4] = {LED1_PIN};
      char path[100];
      char cmd_export[100];
      int i;
  
      char *str;
      int fd;
      int cnt_w;      //写入的字节数
  
      //判断LED对应的操作文件夹是否存在，不存在自动创建
      for(i = 0; i < 3; i++){
          sprintf(path, "%spwm%d", PWM_PATH, 2+led_table[i]); 
          //路径为：sys/class/pwm/pwmchip2/pwm2
  
          if (!access(path, 0))
              printf("%s 文件夹存在\n", path);
          else{
              printf("%s 文件夹不存在\n", path);
              sprintf(cmd_export, "echo %d > %sexport", led_table[i], PWM_PATH);
              //echo 0 > /sys/class/pwm/pwmchip2/export
              system(cmd_export); //执行export命令
  
              if(!access(path, 0))    //访问文件夹,确认创建成功
                  printf("%s 导出成功\n", path);
              else
                  return -1;
          }
      }
  
      //设置基本参数
      for(i = 0; i < 1; i++){
          setargs(led_table, 0, "period", "50000");
          setargs(led_table, 0, "polarity", "normal");
          setargs(led_table, 0, "enable", "1");
      }
  
      //呼吸灯效果
      while(1){
          char arg[5];
          for(i = 10000; i < 40000; i++){
              sprintf(arg, "%d", i);
              setargs(led_table, 0, "duty_cycle", arg);
              sleep(0.1);
          }
          for(i = 40000; i > 10000; i--){
              sprintf(arg, "%d", i);
              setargs(led_table, 0, "duty_cycle", arg);
              sleep(0.1);
          }
      }
      return 0;
  }
  
  
  int setargs(int *led_table, int led_pos, char *args, char *input){
      char path[100];
      int fd;
      int cnt_w;      //写入的字节数
  
      sprintf(path, "%spwm%d/%s", PWM_PATH, 2+led_table[led_pos], args); 
      //路径为：/sys/class/pwm/pwmchip2/pwm2/polarity
      fd = open(path, O_RDWR);    //linux系统函数,失败返回-1
      if(fd != -1){//打开成功
          printf("%s 打开成功\n", path);
          cnt_w = write(fd, input, strlen(input));    //linux系统函数
          if(cnt_w <= 0){
              printf("参数写入失败\n");
              return -1;
          }
          else
              printf("参数写入成功\n");
          close(fd);     //linux系统函数,成功返回0
      }
      else{
          printf("%s 文件打开失败\n", path);
          return -1;
      }
  }
  ```

  
