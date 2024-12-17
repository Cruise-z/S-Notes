# 问题现象

1，Show Applications里面找不到Setting，搜索框当然也搜不到；
2，通过屏幕右上角的Wired Settings也打不开Setting；
3，重启之后问题依旧存在。

## 解决办法：

```shell
sudo apt-get update  //更新软件源
sudo apt-get install unity-control-center  //重新安装unity控制中心
sudo apt-get install ubuntu-desktop  //重新安装桌面
```

