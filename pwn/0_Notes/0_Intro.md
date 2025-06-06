# Intro

## 板块图

| <img src="./0_Intro.assets/image-20241231141854648.png" alt="image-20241231141854648" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

软件安全基本原理板块[4-8章]:50%-60%

## 分值分布

### 选择

2p*25

### 简答

5p*4

### 代码分析题

6p*5

很有可能根据经典的CWE漏洞类型来设计题

以下是隐蔽性更强的**CWE漏洞示例**及修复方法：

---

#### CWE-787: 

**Out-of-Bounds Write**

##### 漏洞代码：
```c
#include <stdio.h>
#include <stdlib.h>

void updateArray(int *arr, int size) {
    for (int i = 0; i <= size; i++) { // 边界条件错误
        arr[i] = i * 2; // 越界写入最后一个索引之外
    }
}

int main() {
    int *array = (int *)malloc(5 * sizeof(int));
    if (!array) return 1;

    updateArray(array, 5); // size参数比实际大小多1
    free(array);
    return 0;
}
```

##### 修复方法：
确保边界检查正确，避免越界写。
```c
#include <stdio.h>
#include <stdlib.h>

void updateArray(int *arr, int size) {
    for (int i = 0; i < size; i++) { // 修复条件
        arr[i] = i * 2;
    }
}

int main() {
    int *array = (int *)malloc(5 * sizeof(int));
    if (!array) return 1;

    updateArray(array, 5);
    free(array);
    return 0;
}
```

---

#### CWE-416: 

**Use After Free (UAF)**

##### 漏洞代码：
```c
#include <stdio.h>
#include <stdlib.h>

void modifyArray(int *arr) {
    free(arr); // 内存释放
    arr[0] = 42; // UAF：使用已释放的内存
}

int main() {
    int *array = (int *)malloc(10 * sizeof(int));
    if (!array) return 1;

    modifyArray(array); // array 被释放后仍然使用
    free(array);
    return 0;
}
```

##### 修复方法：
释放内存后将指针置为 `NULL`，并避免再次使用。
```c
#include <stdio.h>
#include <stdlib.h>

void modifyArray(int **arr) {
    free(*arr);
    *arr = NULL; // 置为 NULL，避免 UAF
}

int main() {
    int *array = (int *)malloc(10 * sizeof(int));
    if (!array) return 1;

    modifyArray(&array); // 传递指针的地址
    if (array) {
        free(array);
    }
    return 0;
}
```

---

#### CWE-415: 

**Double Free**

##### 漏洞代码：
```c
#include <stdio.h>
#include <stdlib.h>

void freeMemory(int *arr) {
    free(arr);
}

int main() {
    int *array = (int *)malloc(10 * sizeof(int));
    if (!array) return 1;

    freeMemory(array); // 第一次释放
    free(array);       // 第二次释放
    return 0;
}
```

##### 修复方法：
确保释放指针后立即置为 `NULL`。
```c
#include <stdio.h>
#include <stdlib.h>

void freeMemory(int **arr) {
    free(*arr);
    *arr = NULL;
}

int main() {
    int *array = (int *)malloc(10 * sizeof(int));
    if (!array) return 1;

    freeMemory(&array); // 避免双重释放
    if (array) {
        free(array);
    }
    return 0;
}
```

---

#### CWE-125: 

**Out-of-Bounds Read**

##### 漏洞代码：
```c
#include <stdio.h>

int getValue(int *arr, int size, int index) {
    return arr[index]; // 未检查索引是否合法
}

int main() {
    int data[5] = {1, 2, 3, 4, 5};
    printf("Value: %d\n", getValue(data, 5, 6)); // 索引越界
    return 0;
}
```

##### 修复方法：
添加索引范围检查。
```c
#include <stdio.h>

int getValue(int *arr, int size, int index) {
    if (index < 0 || index >= size) {
        printf("Index out of bounds\n");
        return -1;
    }
    return arr[index];
}

int main() {
    int data[5] = {1, 2, 3, 4, 5};
    printf("Value: %d\n", getValue(data, 5, 6));
    return 0;
}
```

---

#### CWE-78: 

**OS Command Injection**

##### 漏洞代码：
```c
#include <stdio.h>
#include <stdlib.h>

void runCommand(char *input) {
    char command[128];
    snprintf(command, sizeof(command), "ls %s", input); // 未验证输入
    system(command); // 命令注入漏洞
}

int main() {
    char userInput[50];
    printf("Enter directory: ");
    scanf("%49s", userInput);
    runCommand(userInput);
    return 0;
}
```

##### 修复方法：
严格验证输入，或者避免直接使用 `system`。
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void runCommand(char *input) {
    if (strpbrk(input, "&;|<>")) { // 检查危险字符
        printf("Invalid input detected\n");
        return;
    }
    char command[128];
    snprintf(command, sizeof(command), "ls %s", input);
    system(command);
}

int main() {
    char userInput[50];
    printf("Enter directory: ");
    scanf("%49s", userInput);
    runCommand(userInput);
    return 0;
}
```

---

#### CWE-362: 

**Race Condition**

##### 漏洞代码：
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

void writeFile() {
    int fd = open("temp.txt", O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        perror("Open failed");
        return;
    }
    sleep(2); // 模拟延迟，其他进程可能在此期间修改文件
    write(fd, "Data", 4);
    close(fd);
}

int main() {
    writeFile();
    return 0;
}
```

##### 修复方法：
使用文件锁定机制确保独占访问。

> **`flock()` 的常用锁定模式：**
>
> | 锁定模式            | 描述                                                         |
> | ------------------- | ------------------------------------------------------------ |
> | `LOCK_EX`           | 独占锁：仅允许一个进程获得此锁，其他进程必须等待锁释放。     |
> | `LOCK_SH`           | 共享锁：允许多个进程同时获得此锁，但不能与独占锁共存。       |
> | `LOCK_UN`           | 解锁：释放当前进程持有的锁，允许其他进程访问文件。           |
> | `LOCK_NB`（非阻塞） | 可与 `LOCK_EX` 或 `LOCK_SH` 一起使用，如果无法获取锁立即返回。 |
>
> **运行逻辑**
>
> 1. 加锁：
>
>    - ```c
>      flock(fd, LOCK_EX | LOCK_NB)
>      ```
>
>      - 如果成功，返回 `0`，程序继续运行。
>      - 如果失败，返回 `-1`，并通过 `errno` 判断是否是由于文件已被锁定（`EWOULDBLOCK`）。
>
> 2. 解锁：
>
>    - ```c
>      flock(fd, LOCK_UN)
>      ```
>
>      - 成功返回 `0`。
>      - 失败返回 `-1`，通常是因为文件描述符无效或文件已关闭。

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/file.h>

void writeFile() {
    int fd = open("temp.txt", O_RDWR | O_CREAT, 0666);
    if (fd < 0) {
        perror("Open failed");
        return;
    }
    if (flock(fd, LOCK_EX) < 0) { // 文件锁定
        perror("Lock failed");
        close(fd);
        return;
    }
    write(fd, "Data", 4);
    flock(fd, LOCK_UN); // 释放锁
    close(fd);
}

int main() {
    writeFile();
    return 0;
}
```

---

#### CWE-20: 

**Improper Input Validation**

##### 漏洞代码：
```c
#include <stdio.h>

int divide(int a, int b) {
    return a / b; // 未检查除数是否为0
}

int main() {
    int x = 10, y = 0;
    printf("Result: %d\n", divide(x, y)); // 崩溃
    return 0;
}
```

##### 修复方法：
检查输入参数，避免无效操作。
```c
#include <stdio.h>

int divide(int a, int b) {
    if (b == 0) {
        printf("Error: Division by zero\n");
        return 0;
    }
    return a / b;
}

int main() {
    int x = 10, y = 0;
    printf("Result: %d\n", divide(x, y));
    return 0;
}
```

---

#### CWE-134: 

**Uncontrolled Format String**

##### 漏洞代码：
```c
#include <stdio.h>

void printMessage(char *msg) {
    printf(msg); // 格式化字符串漏洞
}

int main() {
    char input[50];
    printf("Enter message: ");
    scanf("%49s", input);
    printMessage(input);
    return 0;
}
```

##### 修复方法：
使用固定的格式化字符串。
```c
#include <stdio.h>

void printMessage(char *msg) {
    printf("%s", msg); // 修复：避免直接使用输入作为格式化字符串
}

int main() {
    char input[50];
    printf("Enter message: ");
    scanf("%49s", input);
    printMessage(input);
    return 0;
}
```

---

#### CWE-190：

**整数溢出或绕回 (Integer Overflow or Wraparound)**

##### 漏洞代码：

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    unsigned int size = 0xFFFFFFF0; // 大值接近上限
    size += 16; // 触发整数溢出
    printf("Allocated size: %u\n", size);

    void *buffer = malloc(size); // 无效的内存分配
    if (buffer == NULL) {
        perror("Memory allocation failed");
        return 1;
    }
    free(buffer);
    return 0;
}
```

##### 修复方法： 

在操作前检查整数是否会溢出。

```c
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main() {
    unsigned int size = 0xFFFFFFF0;
    if (size > UINT_MAX - 16) { // 检查溢出
        printf("Integer overflow detected\n");
        return 1;
    }

    size += 16;
    printf("Allocated size: %u\n", size);

    void *buffer = malloc(size);
    if (buffer == NULL) {
        perror("Memory allocation failed");
        return 1;
    }
    free(buffer);
    return 0;
}
```

------

#### 总结

这些示例隐蔽性更强，通常以微妙的错误或疏漏为特点。例如错误的边界条件、输入验证不足、延迟操作带来的竞争问题等。修复方法通过添加边界检查、输入验证或同步机制解决问题，同时提高代码安全性。



## P3：软件安全

### C程序的生成过程

#### 概览图

| <img src="./0_Intro.assets/image-20250102213059088.png" alt="image-20250102213059088" style="zoom: 33%;" /> |
| :----------------------------------------------------------: |

- 预处理器：

  处理宏命令（.c$\rightarrow$.c）

- 编译器：

  生成汇编代码（.c$\rightarrow$.s）

- 汇编器：

  生成目标二进制代码（.s$\rightarrow$.o）

- 链接器：

  链接其它文件和库生成可执行文件 hello（.o$\rightarrow$.elf）

### 汇编指令解释

#### 方括号[]的学问

**对比：`LEA` 与其他指令中方括号的意义**

| 指令类型        | 方括号的含义                 | 示例               | 结果                      |
| --------------- | ---------------------------- | ------------------ | ------------------------- |
| **`LEA`**       | 地址计算，返回地址值         | `lea rdx, [rax-1]` | `rdx = rax - 1`           |
| **`MOV`/`ADD`** | 内存访问，读取或写入内存内容 | `mov eax, [ebx]`   | 从地址 `ebx` 读取到 `eax` |
| **`MOV`**       | 内存访问，写入内存内容       | `mov [ebx], eax`   | 将 `eax` 写入地址 `ebx`   |

`LEA` 的常用形式灵活多变，可以支持：

1. 简单的基址偏移计算；
2. 复杂的基址、索引和比例计算；
3. 高效完成某些算术运算（加法、减法、乘法）；
4. 地址计算场景（如数组和指针运算）。

它的强大之处在于：

- 能够在一条指令中完成复杂的地址计算，
- 同时避免额外的内存访问和标志寄存器修改

是编写高效汇编代码的关键指令之一

### 常用寄存器

| <img src="./0_Intro.assets/image-20250103201140628.png" alt="image-20250103201140628" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

### 攻防技术的演进

略

### 内存布局

略

### elf可执行文件的常见section

略

## P4：软件安全原则

三原则（隔离-最小权限-区域化）

stride方法（六类威胁）

> **漏洞和缺陷的区别**
>
> 漏洞是可被利用以达到攻击目的的缺陷
> 但缺陷是程序未能按照设计规格或用户需求正确工作的问题，他不一定是漏洞

## P5：内存与类型安全

夺命五连问：

| <img src="./0_Intro.assets/image-20241231143435140.png" alt="image-20241231143435140" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

### Q1：

#### 内容

基于编程语言的安全 (Language-based Security， LS) 是指由编程语言提供的特性或机制，这些 特性或机制有助于构建安全的软件。

LS主要包括以下两个方面：

- 内存安全 (Memory Safety) 
- 类型安全 (Type Safety)
- 并发安全 (Concurrency Safety)
- 运行时安全

等等；

#### 类型

语言从安全角度分为强类型和弱类型、自动内存管理和手动内存管理、安全设计语言和性能优先语言等类别。选择适合特定应用场景的语言是保障安全性的关键。

### Q2：

直接通过内存地址操作内存内容，包括得到变量的内存地址，对内存地址处内容赋值，取出等

### Q3：

#### 定义

内存安全 (Memory safety) 确保程序中的指针总是指向有效的内存区域或内存对象;
分为时间内存安全和空间内存安全

#### C/C++缺陷

- 时间内存安全：

  C/C++采用手动内存管理的方式（也是为了保证运行速度），会导致悬挂指针、UAF这样的在指针时效期外的误用

- 空间内存安全：

  C/C++中由于没有对数组边界的强制检查，导致指针使用时出现越界这样的违背空间内存安全的情况

### Q4：

#### 定义：

类型安全是编程语言中的一种概念：
它为每个分配的内存对象赋予一 个类型，被赋予类型的内存对象只能在期望对应类型的程序点使用。

#### C/C++区别：

- C可以说是完全的类型不安全，允许在很多情况下隐式地将一种类型转换为另一种类型，这可能导致数据丢失或行为异常。

- C++相较于C好一些，有dynamic_cast等运行时内存检查的手段，但是他也不是完全的类型安全，其仍允许使用const_cast等危险的强制类型转换

### Q5:

#### Java

##### 内存安全

###### 内存时间安全

引入了GC（内存回收机制），同时java不允许对内存直接操作，即关闭用户操作内存的接口

###### 内存空间安全

Java的集合类以及数据内置了边界检查

##### 类型安全

Java是强类型语言：

- 在编译和运行时会对类型进行检查
- 所有变量的类型在编译时就必须明确
- 集合框架中引入了泛型，确保类型安全，避免了运行时类型转换错误

#### Rust

> Rust 是一种现代系统编程语言，通过语言设计和编译器的严格检查，在不依赖垃圾回收器的情况下，提供了极高的内存安全性和类型安全性。Rust 的独特特性如**所有权机制**、**借用检查**和**强类型系统**，有效地解决了内存与类型安全问题。
>
> ---
>
> ###### Rust 如何解决内存安全问题
>
> Rust 的内存安全机制主要依赖于其**所有权系统**和**编译时检查**，避免了许多传统语言（如 C/C++）中常见的内存错误。
>
> **所有权机制**
>
> Rust 通过所有权（Ownership）规则管理内存，确保每块内存有明确的所有者，并在生命周期结束时自动释放。
>
> - 规则：
>   1. 每个值有且只有一个所有者。
>   2. 当所有者离开作用域时，值会被自动清理（即内存自动释放）。
>
> | **特性**         | **Rust 的解决方式**                                        |
> | ---------------- | ---------------------------------------------------------- |
> | **时间内存安全** | 所有权机制、生命周期检查、禁止悬挂指针、自动释放内存       |
> | **空间内存安全** | 边界检查、禁止未初始化变量、避免缓冲区溢出                 |
> | **类型安全**     | 强类型系统、无隐式类型转换、泛型检查、模式匹配覆盖所有分支 |
> | **潜在局限性**   | `unsafe` 块的使用需谨慎，外部库可能引入不安全因素          |
>
> Rust 通过其语言特性和编译器的严格检查，在保证高性能的同时，最大程度上解决了内存和类型安全问题，成为现代系统编程的安全首选。

##### `Rust`$\leftrightarrow$`C/C++`

###### `堆内存`中所有权机制

| `Rust指针赋值`和`C/C++的浅拷贝` | <img src="./0_Intro.assets/image-20250104173620063.png" alt="image-20250104173620063" style="zoom: 33%;" /> |
| :-----------------------------: | :----------------------------------------------------------: |
|  **`Rust`函数调用所有权转移**   | <img src="./0_Intro.assets/image-20250104174211390.png" alt="image-20250104174211390" style="zoom: 33%;" /> |
|  **`Rust借用`和`C/C++的引用`**  | <img src="./0_Intro.assets/image-20250104174336646.png" alt="image-20250104174336646" style="zoom: 33%;" /><img src="./0_Intro.assets/image-20250104174358059.png" alt="image-20250104174358059" style="zoom: 33%;" /> |

##### `Quiz: 辨析`

| <img src="./0_Intro.assets/image-20250117172230948.png" alt="image-20250117172230948"  /> | <u>==`ANS`==</u><br />左侧代码会报错，右侧代码不会报错<br />`LHS`：左侧`r1`、`r2`、`r3`在<u>`println!()`</u>宏输出前对变量`s`属于同一个作用域，而在`s`的同一个作用域中，引用于可变引用不可同时存在；<br />`RHS`：右侧`r1`、`r2`在<br /><u>`println!("{} and {}", r1,r2)`</u><br />宏输出后即被回收，此时对`s`可变引用没有问题。 |
| :----------------------------------------------------------: | :----------------------------------------------------------- |



### Q6：什么是向上转型以及向下转型

> **向上转型（Upcasting）** 和 **向下转型（Downcasting）** 是面向对象编程中与继承和多态相关的概念，主要用于在类的继承体系中进行类型转换。
>
> ---
>
> ###### **1. 向上转型（Upcasting）**
>
> ###### **定义**
> - 向上转型是将**子类对象**转换为**父类类型**的过程。
> - 向上转型是安全的，并且通常是**隐式**的，因为子类对象本身就是父类的一种。
>
> ###### **特点**
> 1. **安全性**：
>    - 子类总是包含父类的所有特性，因此向上转型不会丢失父类的属性和方法。
>    - 只能访问父类中声明的成员，无法访问子类的特有成员。
> 2. **隐式转换**：
>    - 编译器会自动进行向上转型，无需显式声明。
>
> ###### **代码示例（Java）**
> ```java
> class Parent {
>     void display() {
>         System.out.println("Parent class method");
>     }
> }
> 
> class Child extends Parent {
>     void childMethod() {
>         System.out.println("Child class method");
>     }
> }
> 
> public class Main {
>     public static void main(String[] args) {
>         Child child = new Child();
>         Parent parent = child; // 向上转型，隐式转换
>         parent.display();      // 调用父类的方法
>         // parent.childMethod(); // 编译错误，父类类型无法访问子类特有方法
>     }
> }
> ```
>
> ###### **总结**
> - 向上转型的本质是将子类对象视为其父类类型。
> - 优势：实现多态（例如方法的动态绑定）。
>
> ---
>
> ###### **2. 向下转型（Downcasting）**
>
> ###### **定义**
> - 向下转型是将**父类对象**转换为**子类类型**的过程。
> - 向下转型通常是**显式的**，并且需要程序员保证安全性。
>
> ###### **特点**
> 1. **不安全性**：
>    - 并非所有父类对象都能安全地向下转型为子类类型，错误的向下转型会引发运行时异常（`ClassCastException`）。
> 2. **需要显式转换**：
>    - 编译器要求显式声明向下转型，以提示开发者注意类型安全。
>
> ###### **代码示例（Java）**
> ```java
> class Parent {
>     void display() {
>         System.out.println("Parent class method");
>     }
> }
> 
> class Child extends Parent {
>     void childMethod() {
>         System.out.println("Child class method");
>     }
> }
> 
> public class Main {
>     public static void main(String[] args) {
>         Parent parent = new Child(); // 向上转型
>         Child child = (Child) parent; // 向下转型，显式转换
>         child.childMethod();         // 子类特有方法可以被访问
> 
>         // 错误示例
>         Parent anotherParent = new Parent(); // 父类对象
>         Child anotherChild = (Child) anotherParent; // 编译通过，但运行时抛出 ClassCastException
>     }
> }
> ```
>
> ###### **如何安全地向下转型**
> 使用 `instanceof` 检查对象是否属于目标类型：
> ```java
> if (parent instanceof Child) {
>     Child child = (Child) parent;
>     child.childMethod();
> }
> ```
>
> ---
>
> ###### **3. 向上转型 vs 向下转型**
>
> | **特性**         | **向上转型（Upcasting）**        | **向下转型（Downcasting）**           |
> | ---------------- | -------------------------------- | ------------------------------------- |
> | **定义**         | 将子类对象转换为父类类型         | 将父类对象转换为子类类型              |
> | **安全性**       | 安全，子类总是包含父类的所有特性 | 不安全，可能引发 `ClassCastException` |
> | **转换方式**     | 隐式转换                         | 必须显式转换                          |
> | **是否需要检查** | 不需要，编译器自动处理           | 需要开发者确保类型安全性              |
> | **可访问成员**   | 只能访问父类成员                 | 可访问子类成员                        |
> | **用途**         | 实现多态、通用接口               | 需要使用子类的特有功能                |
>
> ---
>
> ###### **4. 实际应用场景**
>
> ###### **向上转型的应用**
> 1. **多态实现**：
>    - 父类引用可以指向子类对象，通过动态绑定调用子类的重写方法。
>    - **示例**：
>      ```java
>      Parent obj = new Child(); // 向上转型
>      obj.display();            // 调用子类的重写方法
>      ```
>
> 2. **通用处理**：
>    - 允许将子类对象存储在一个父类类型的集合中，便于统一处理。
>    - **示例**：
>      ```java
>      List<Parent> list = new ArrayList<>();
>      list.add(new Child());
>      ```
>
> ###### **向下转型的应用**
> 1. **访问子类特有功能**：
>    - 当父类引用实际上指向一个子类对象时，可以通过向下转型访问子类特有的方法或属性。
>    - **示例**：
>      ```java
>      Parent obj = new Child();
>      if (obj instanceof Child) {
>          Child child = (Child) obj;
>          child.childMethod();
>      }
>      ```
>
> ---
>
> ###### **5. 总结**
>
> - **向上转型**：安全、隐式，用于多态和通用接口处理。
> - **向下转型**：不安全、显式，用于需要访问子类特有功能的场景，但需谨慎使用，确保类型正确性。

## P6/P7：软件安全攻击手段与防御策略

### 攻击面以及攻击向量

| <img src="./0_Intro.assets/image-20250104095319435.png" alt="image-20250104095319435" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

### CIA与软件攻击手段

| <img src="./0_Intro.assets/image-20250104095424833.png" alt="image-20250104095424833" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

### 软件攻击方法

#### 拒绝服务

##### 攻击效果

| <img src="./0_Intro.assets/image-20250104095639641.png" alt="image-20250104095639641" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

##### 实例

###### 用户输入影响目标程序内存对象分配

内存耗尽

###### 用户输入导致目标程序崩溃

缓冲区溢出

###### XpdfReader拒绝服务攻击

#### 信息泄露

##### 实例

###### SSL “心跳”机制

攻击者构造一个恶意的心跳请求包，在请求包中设定一个很大的载荷长度，在使用 memcpy 函数来填充心跳响应包的载荷时，会将服务端对应载荷长度的内存数据填入应答包中，导致信息泄露。

###### 泄露内存中敏感地址

便于后续的栈溢出攻击

#### 提权

##### 常见的提权手段

###### 控制流劫持

###### 命令注入

##### 两类提权攻击

###### 远程代码执行

###### 本地权限提升

#### *混淆代理人(Confused deputy）问题

##### 定义

| <img src="./0_Intro.assets/image-20250104102539846.png" alt="image-20250104102539846" style="zoom:33%;" /> |
| :----------------------------------------------------------: |

##### 实例

###### D-Bus漏洞及polkit保护

| <img src="./0_Intro.assets/image-20250104102708734.png" alt="image-20250104102708734" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104102731140.png" alt="image-20250104102731140" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

#### ROP等内存漏洞利用技术

略（pwn中已有介绍）

#### 竞争条件漏洞

| <img src="./0_Intro.assets/image-20250104153731210.png" alt="image-20250104153731210" style="zoom: 33%;" /> |
| :----------------------------------------------------------: |

| <img src="./0_Intro.assets/image-20250104154258037.png" alt="image-20250104154258037" style="zoom: 25%;" /> | <img src="./0_Intro.assets/image-20250104154505094.png" alt="image-20250104154505094" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./0_Intro.assets/image-20250104154326017.png" alt="image-20250104154326017" style="zoom: 25%;" /> | <img src="./0_Intro.assets/image-20250104154548740.png" alt="image-20250104154548740" style="zoom: 25%;" /> |

本质上还是操作之间的不连贯性，因为两不可间隔操作并非原子操作导致的

### 软件漏洞缓解措施

#### Fortify Source(不考)

#### 控制流完整性CFI(了解)

| <img src="./0_Intro.assets/image-20250104155657612.png" alt="image-20250104155657612" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104155717578.png" alt="image-20250104155717578" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./0_Intro.assets/image-20250104155836220.png" alt="image-20250104155836220" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104155857784.png" alt="image-20250104155857784" style="zoom:25%;" /> |
| <img src="./0_Intro.assets/image-20250104161437035.png" alt="image-20250104161437035" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104161501787.png" alt="image-20250104161501787" style="zoom:25%;" /> |

> ##### `JOP` 和 `COP` 的比较
>
> | 特性           | JOP                      | COP                                  |
> | -------------- | ------------------------ | ------------------------------------ |
> | **目标指令**   | 跳转指令（`jmp` 等）     | 函数调用指令（`call` 等）            |
> | **依赖性**     | 依赖代码片段（gadgets）  | 依赖函数或指针                       |
> | **攻击复杂性** | 构造跳转表较复杂         | 修改函数指针或虚表相对更直接         |
> | **使用场景**   | 绕过栈保护和返回地址保护 | 在复杂程序中利用现有函数执行恶意行为 |
>
> ##### 影子栈无法防御 JOP 和 COP 的根本原因
>
> | 特性               | JOP                                  | COP                                            |
> | ------------------ | ------------------------------------ | ---------------------------------------------- |
> | **依赖的指令**     | 跳转指令（`jmp`、`call`）            | 函数调用指令（`call`）                         |
> | **影子栈保护范围** | 仅保护返回地址                       | 仅保护返回地址                                 |
> | **攻击操作**       | 攻击者修改跳转目标，无需修改返回地址 | 攻击者修改函数指针或虚表指针，无需修改返回地址 |
> | **影子栈的局限性** | 不保护跳转目标地址                   | 不保护函数指针或调用目标                       |

##### Windows CFG

Windows从Win8开始引入控制流完整性保护（Windows Control Flow Guard (CFG)）

###### 优缺点

| 优点                                                         | 缺点                                                         |
| ------------------------------------------------------------ | :----------------------------------------------------------- |
| 通过一定的简化，使得CFI能 够真正进入商业化操作系统中 ，取得实效<br />能够兼容旧系统<br />性能损失控制在可接受范围内 | 只能提供粗粒度(8 Bytes)的间接 调用的保护<br />只提供跳转点的保护，不能检测合法跳转点组成的非法执行路径<br />对于内核来说性能损失还比较大<br />不能保护动态生成的代码（比如 JIT） |

###### 绕过

劫持guard_check_icall_ptr函数指针：

- **覆盖 `guard_check_icall_ptr`**

  `guard_check_icall_ptr` 本质上是一个全局函数指针，存储在某个固定的全局地址（通常位于 `.rdata` 段）。如果攻击者能够找到并覆盖它，就可以将检查逻辑替换为任意代码。

- 如果攻击者无法直接覆盖 `guard_check_icall_ptr`，可以尝试利用其他方式绕过合法目标检查：

  - **方法 1：将恶意代码伪装为合法目标**：
    - CFG 合法目标存储在全局表中。攻击者可以尝试利用某些漏洞将恶意地址插入该表。
    - 常见漏洞：
      - 修改合法目标表（如覆盖 `.rdata` 段）。
      - 替换合法目标函数的代码。
  - **方法 2：覆盖合法函数指针**：
    - 如果程序中有合法的函数指针被使用，攻击者可以利用内存写入漏洞将这些指针替换为恶意代码地址。

#### 代码指针完整性CPI

| <img src="./0_Intro.assets/image-20250104165300943.png" alt="image-20250104165300943" style="zoom:33%;" /> | 敏感指针的定位：<br />以敏感类型为终点，<br />找到所有最终指向该敏感类型的有向图的一条路径，<br />该路径中的所有指针均为敏感指针 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./0_Intro.assets/image-20250104165714271.png" alt="image-20250104165714271" style="zoom: 33%;" /> | <img src="./0_Intro.assets/image-20250104165740631.png" alt="image-20250104165740631" style="zoom: 30%;" /> |

#### 沙箱与基于软件的错误隔离

| <img src="./0_Intro.assets/image-20250104172030392.png" alt="image-20250104172030392" style="zoom: 33%;" /> |
| :----------------------------------------------------------: |

| <img src="./0_Intro.assets/image-20250104172230764.png" alt="image-20250104172230764" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104172254389.png" alt="image-20250104172254389" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./0_Intro.assets/image-20250104172359201.png" alt="image-20250104172359201" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250104172424410.png" alt="image-20250104172424410" style="zoom:25%;" /> |



## P8：软件安全分析基础

反调试

模糊测试的关键点

### 逆向工程

庖丁解牛

### 静态分析方法

#### `CodeQl`:灵活静态分析

| **CodeQL 的核心概念**                                        | 查询语句的约束分析<br />查询约束过强(过于细致)$\rightarrow$must分析$\rightarrow$漏报<br />查询约束过弱(过于宽泛)$\rightarrow$may分析$\rightarrow$误报 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **数据库生成**：  CodeQL 通过解析源代码，生成代码的数据库（CodeQL Database）。 数据库包含代码的结构化表示，例如函数调用、变量定义、控制流等。<br />**查询语言**：  使用 CodeQL 查询语言，开发者可以编写规则，搜索代码中可能存在的问题。 查询语法基于 Datalog（逻辑编程语言），并扩展了对程序语义的支持。 <br />**查询库**：  提供了一系列预定义的查询，用于检测常见的安全漏洞（如 SQL 注入、跨站脚本攻击等）和代码质量问题。 | <img src="./0_Intro.assets/image-20250105195248510.png" alt="image-20250105195248510"  /> |

#### 控制流分析

| <img src="./0_Intro.assets/image-20250105195813694.png" alt="image-20250105195813694" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250105195831634.png" alt="image-20250105195831634" style="zoom:25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

#### 数据流分析

| <img src="./0_Intro.assets/image-20250105200415116.png" alt="image-20250105200415116" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250105200845257.png" alt="image-20250105200845257" style="zoom: 33%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

### 反调试技术

|      概述      | <img src="./0_Intro.assets/image-20250105201604271.png" alt="image-20250105201604271" style="zoom: 25%;" /> |
| :------------: | :----------------------------------------------------------: |
| 静态反调试技术 | <img src="./0_Intro.assets/image-20250105201701342.png" alt="image-20250105201701342" style="zoom: 25%;" /> |
| 动态反调试技术 | <img src="./0_Intro.assets/image-20250105201912261.png" alt="image-20250105201912261" style="zoom: 25%;" /> |

### 模糊测试

AFL – 最有影响力的开源模糊测试框架

| <img src="./0_Intro.assets/image-20250105202217300.png" alt="image-20250105202217300" style="zoom: 25%;" /> | <img src="./0_Intro.assets/image-20250105202306561.png" alt="image-20250105202306561" style="zoom: 25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

| **测试数据生成** | <img src="./0_Intro.assets/image-20250105202354692.png" alt="image-20250105202354692" style="zoom: 20%;" /><img src="./0_Intro.assets/image-20250105202444957.png" alt="image-20250105202444957" style="zoom:20%;" /> |
| :--------------: | :----------------------------------------------------------: |

| <img src="./0_Intro.assets/image-20250105202648553.png" alt="image-20250105202648553" style="zoom: 25%;" /> | <img src="./0_Intro.assets/image-20250105202733986.png" alt="image-20250105202733986" style="zoom:25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

| <img src="./0_Intro.assets/image-20250105203108880.png" alt="image-20250105203108880" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250105203131433.png" alt="image-20250105203131433" style="zoom:25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

## P9：移动APP安全

### 安卓

| <img src="./0_Intro.assets/image-20250105203613192.png" alt="image-20250105203613192" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250105203634899.png" alt="image-20250105203634899" style="zoom:25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

### IOS

| <img src="./0_Intro.assets/image-20250105203942716.png" alt="image-20250105203942716" style="zoom:25%;" /> | <img src="./0_Intro.assets/image-20250105203752990.png" alt="image-20250105203752990" style="zoom:25%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

