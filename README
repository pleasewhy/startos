## StartOS

StartOS是一个RISC-V 64位操作系统，它主要使用C++编写并包含一些必要的汇编代码

写StartOS的主要是为了学习和作为一个校招的项目

### Features

- [x] 64位操作系统(RISC-V)

- [x] 运行ELF格式程序

- [x] VFS和FAT32文件系统

- [x] SD/RTC驱动

- [x] 虚拟内存和内存管理

- [x] 控制台IO

- [x] 进程管理

### TODO

- [ ] STL标准库
- [ ] 使用C++特性
- [ ] 设备管理
- [ ] 线程安全的文件系统

### 开发工具

- k210开发板或者qemu-system-riscv64

  ```shell
  sudo apt-get install qemu-system-misc=1:4.2-3ubuntu6 # 需要4.2版本
  ```

- RISC-V 交叉编译工具包

  ```shell
  sudo apt-get install git build-essential gdb-multiarch gcc-riscv64-unknown-elf binutils-riscv64-linux-gnu 
  ```

  注意：最好使用Ubuntu20版本

### 下载

```shell
git clone git@github.com:pleasewhy/startos.git
```

### 运行

#### qemu

首先制作一个FAT32磁盘镜像

```shell
make fs.img
```

该命令会生成`fs.img`磁盘镜像，并将submit/riscv64/目录下的文件添加到fs.img中

然后修改platform.mk的platform修改为QEMU

![image-20210526195907352](./doc/img/platform.png)

最后运行

```shell
make qemu
```

你会得到如下输出

退出：输入`Ctrl+A`，然后`X`退出QEMU

#### K210

`startOS`目前只支持在k210 Sipeed M1 DOCK开发板上运行。

首先需要制作一个FAT32格式的sd卡，sd卡默认路径为/dev/sdb，你需要将其替换为你的sd卡路径。

```shell
make sd
```

将sd插入k210开发板，并将其连接到电脑上，k210的默认连接路径为/dev/ttyUSB0，你需要将其替换为你的开发板路径。

然后你需要修改platform.mk的platform修改为K210

最后运行

```shell
make k210
```