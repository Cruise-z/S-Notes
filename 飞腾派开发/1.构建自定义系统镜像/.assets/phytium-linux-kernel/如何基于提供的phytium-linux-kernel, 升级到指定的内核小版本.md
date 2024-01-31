以5.10分支为例，我们当前提供的版本是5.10.153，如果你需要升级到更高版本的内核patch，可以进行如下操作：
假设本地已经有clone过当前仓库：
  `git clone git@gitee.com:phytium_embedded/phytium-linux-kernel.git`

1. remote增加linux-stable。
`git remote add linux-stable https://mirrors.tuna.tsinghua.edu.cn/git/linux-stable.git`
2. 拉取特定分支的内容，此处拉取5.10.y和tags
`git fetch linux-stable linux-5.10.y --tags`
3. 基于linux-stable的v5.10.197创建一个临时分支(假设你需要工作在5.10.197)
`git checkout -b tmp_5.10.197 v5.10.197`
4. 将我们仓库linux-5.10中(cfb0c884938f1 Initial codes from Linux 5.10.153)到最新的代码rebase过去。
`git rebase --onto=tmp_5.10.197 cfb0c884938f1 ac84aaa013075`

中间可能会发生冲突，比如下面这个，如果遇到无法解决的冲突，可以再提issue给我们来分析。

```
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@@ -4964,8 -4942,10 +4964,15 @@@ static const struct pci_dev_acs_enable
        { PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
        /* Zhaoxin Root/Downstream Ports */
        { PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
++<<<<<<< HEAD
 +      /* Wangxun nics */
 +      { PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
++=======
+       /* Phytium Technology */
+       { 0x10b5, PCI_ANY_ID, pci_quirk_xgene_acs },
+       { 0x17cd, PCI_ANY_ID, pci_quirk_xgene_acs },
+       { 0x1db7, PCI_ANY_ID, pci_quirk_xgene_acs },
++>>>>>>> Update to kernel_5.10_2023-v1.0-RC1
        { 0 }
  };
```
这种两边都保留就好了。如下：

```
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@@ -4964,8 -4942,10 +4964,12 @@@ static const struct pci_dev_acs_enable
        { PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
        /* Zhaoxin Root/Downstream Ports */
        { PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
 +      /* Wangxun nics */
 +      { PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
+       /* Phytium Technology */
+       { 0x10b5, PCI_ANY_ID, pci_quirk_xgene_acs },
+       { 0x17cd, PCI_ANY_ID, pci_quirk_xgene_acs },
+       { 0x1db7, PCI_ANY_ID, pci_quirk_xgene_acs },
        { 0 }
  };
```
修改完后, 继续rebase。
`git add drivers/pci/quirks.c`
`git rebase --continue`
rebase全部结束后，代码升级完成。
有需要的话，可以再生成单独patch文件：
`git format-patch v5.10.197 --stdout > phytium_patch_in_5.10.197`
