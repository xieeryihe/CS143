本次 Lab 旨在熟悉 Cool 语言，Lab 的目标是实现一个栈机器（Stack Machine），该机器以栈为存储和执行的基础。

启动栈机器后，会创造一个命令行空间并在终端显示 `>`，可以接受以下指令并压入栈中。

- `int`：整数字符
- `d`：显示栈中的内容
- `e`：根据栈顶内容执行以下三种操作
- `+`：将后两个元素相加后重新压入栈
- `s`：互换 s 之后两个元素在栈中的位置
- 如果栈为空或者栈顶元素为整数，则不进行任何操作
- `x`：退出栈机器

## 测试

请在 Cool Lab 的根目录下完成实验，相应的执行结果如下所示：

```shell
% [cool root]/bin/coolc stack.cl atoi.cl
% [cool root]/bin/spim -file stack.s
SPIM Version 5.6 of January 18, 1995
Copyright 1990-1994 by James R. Larus (larus@cs.wisc.edu).
All Rights Reserved.
See the file README a full copyright notice.
Loaded: [cool root]/lib/trap.handler
>1
>+
>2
>s
>d
s
2
+
1
>e
>e
>d
3
>x
COOL program successfully executed
```





