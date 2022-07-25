# Lab4 - 语义分析

## 要求

本次 Lab 需要实现对 Cool 编译器的语义分析，用以判断语法分析得到的抽象语法树（AST）是否符合语法规范。对于错误的程序，你需要在语义分析时给出恰当的错误信息。而对于正确的程序，语义分析的结果将保留在 AST 节点的属性上，最终生成带有这些额外注解的抽象语法树会被代码生成器使用。

本次 Lab 在实现上有较大的自由度，在符合 Cool 语言标准的基础上，可以尽情发挥自己的想法。但记得务必参考 Cool Manual 中定义的 Cool 的类型规则、标识符范围和其它的限制。 在此基础上，你还需要对当前抽象语法树的类定义添加方法和数据。 Cool Tour 中详细记载了关于 AST 的定义和可用的函数。

本次 Lab 的主要任务如下：

1. 找到所有的类并建立继承图
2. 检查继承图是否规范
3. 对于每一个类：
   - 遍历抽象语法树，把所有可见的声明加入到符号表中
   - 检查每一个表达式的类型正确性
   - 给抽象语法树的节点增加类型信息

### 脚本修改

本次 PA4 文件夹中同样封装了对 semant 和 coolc 的调用脚本 `mysemant` 和 `mycoolc`，由于当前目录缺少相应文件，需要进行一定的修改：

```txt
# mysemant
lexer $* | parser $* | ./semant $* 
# mycoolc
lexer $* | parser $* | ./semant $* | cgen $*
```

### 样例测试

针对 `simplearith.test`样例：

```
class Main {
 main(): Object {{5+4; 5-4; 3*2; 3/2;} };
};
```

语义分析在其抽象语法树的基础上额外增加了节点的属性：

```
@@ -17,44 +17,44 @@
           #2
           _int
             5
-          : _no_type
+          : Int
           #2
           _int
             4
-          : _no_type
-        : _no_type
+          : Int
+        : Int
         #2
         _sub
           #2
           _int
             5
-          : _no_type
+          : Int
           #2
           _int
             4
-          : _no_type
-        : _no_type
+          : Int
+        : Int
         #2
         _mul
           #2
           _int
             3
-          : _no_type
+          : Int
           #2
           _int
             2
-          : _no_type
-        : _no_type
+          : Int
+        : Int
         #2
         _divide
           #2
           _int
             3
-          : _no_type
+          : Int
           #2
           _int
             2
-          : _no_type
-        : _no_type
-      : _no_type
+          : Int
+        : Int
+      : Int
     )
```

### 错误样例

针对 `namain.test` 样例：

```
class A {

};
```

语义分析需要给出以下输出：

```
# lexer nomain.test | parser | semant
Class Main is not defined.
Compilation halted due to static semantic errors.
```

```txt
lexer good.cl | parser | semant
```



## 类型检查

作为编译器前端的最后一部分工作，语义分析需要检查抽象语法树中不符合语言规范的错误，比如标示符定义，类继承关系等。此部分主要根据 `cool-manual.pdf` 中第 13 章的内容来完成，具体需要包括以下几点：

### Class 检查

- 在 `class` 符号表中添加了5种基本类（`Object`/ `IO`/ `Int`/ `Bool`/ `Str`）；
- 检查主类 `Main` 和主函数 `main` 是否定义，按照规范应该被定义；
- 检查 `SELF_TYPE` 类是否被定义，按照规范不应该被定义；
- 检查类(`class`)或者函数(`method`)是否被重复定义，按照规范不应该被定义；
- 检查是否存在自定义类继承了 `Int`/`Str`/`Bool`/`SELF_TYPE` 或者未定义的类，按照规范不应该存在；
- 检查类的父类(`parent class`)(默认父类为 `Object`)是否存在，按照规范应该存在；
- 检查类之间继承关系是否构成环，按照规范不应该构成；

### Method 检查

- 当子类重载父类中定义的方法时，检查函数参数数量，参数类型和返回值是否与父类中的定义一致；
- 检查形式参数中是否包含 `self`，按照规范不应该包含；
- 检查形式参数是否被重复定义，按照规范不应该被重复定义；
- 检查形式参数的类型是否被定义，按照规范应该被定义；
- 检查返回类型是否被定义，按照规范应该被定义；
- 检查推导出来的返回类型和声明的返回类型是否一致，按照规范应该一致；

### Attribute 检查

- 检查属性的类型声明是否被定义，按照规范应该定义；
- 检查属性初始化时被推导出的类型与声明是否符号，按照规范应该符合；
- attr不能被重定义，父子类中只要名字一样，就算重定义。
- attr名字不能是self

### Assign 检查

- 检查标识符是否定义，按照规范应该定义；
- 检查 `assign` 语句的返回类型与声明是否一致，按照规范应该一致；

### Dispatch 检查

- 检查静态调用声明的类型是否被定义，仅在静态调用时检查，按照规范应该被定义；
- 检查表达式类型是否被定义，按照规范应该被定义；
- 检查表达式类型与静态调用的声明是否符合，仅在静态调用时检查，按照规范应该符合；
- 检查函数是否被定义，按照规范应该被定义；
- 检查实参和形参的类型是否符合，按照规范应该符合；
- 检查函数调用的参数数量与定义是否符合，按照规范应该符合；

### Cond & Loop检查

- 检查条件表达式返回类型是否是 `Bool` 类型；

### Case / Branch检查

- 检查是否存在重复分支，按照规范不应该存在；

### Let 检查

- 检查标识符声明的类型是否被定义；
- 检查标识符初始化过程中被推导出的类型是否与声明相符；

### Plus, Sub, Mul, Div, Neg, LT, LEQ (+, -, *, /, ~, <, <=)

- 检查是否所有参数都是 `Int` 类型；

### EQ 检查 (=)

- 如果其中一个参数是 `Int`、`Bool` 或者 `String` 类型，其他参数也应该是相同类型；

### Comp 检查 (not)

- 检查参数类型是否为 `Bool` 类型；

### New 检查

- 检查 `new` 是否被用于未定义的类，按照规范不应该；

### Object 检查

- 检查标识符是否被声明；

## 测试

### 测试样例

本次 Lab 共 74 个测试文件，可从 [http://10.176.36.25:10143/lab4_test_cases.zip (链接到外部网站。)](http://10.176.36.25:10143/lab4_test_cases.zip) 获取

### 测试脚本

本次 Lab 使用以下脚本统计样例成功情况，该脚本可以直接从 [https://pastebin.com/3EAdZT2b (链接到外部网站。)](https://pastebin.com/3EAdZT2b) 获取：

```
import os
import sys
 
 
def test_case(lexer_path, parser_path, semant_path, pa4_semant_path, case_path):
    os.system('{} {} | {} | {} > /tmp/output1 2>&1;'.format(lexer_path, case_path, parser_path, semant_path))
    os.system('{} {} | {} | {} > /tmp/output2 2>&1;'.format(lexer_path, case_path, parser_path, pa4_semant_path))
 
    result = os.popen('diff -u /tmp/output1 /tmp/output2').read()
 
    return len(result) == 0


def test_pa4(project_dir):
    pa3_dir = os.path.join(project_dir, 'assignments/PA4')
    bin_dir = os.path.join(project_dir, 'bin')
    test_cases_dir = os.path.join(project_dir, 'lab4_test_cases')
    if not os.path.exists(test_cases_dir):
        print('plz put the test cases dir under the root of project...')
        exit(0)
    test_cases = os.listdir(test_cases_dir)
    test_cases_pathes = [os.path.join(test_cases_dir, test_case) for test_case in test_cases]
    
    # make semant
    print('start make semant...')
    os.system('cd {}; make clean; make semant;'.format(pa3_dir))
    lexer = os.path.join(bin_dir, 'lexer')
    parser = os.path.join(bin_dir, 'parser')
    semant = os.path.join(bin_dir, 'semant')
    pa4_semant = os.path.join(pa3_dir, 'semant')
    if os.path.exists(pa4_semant):
        print('make semant successfully!')
    else:
        print('make semant failed!')
        exit(1)

    # test
    print('start testing...')
    count = len(test_cases_pathes)
    successful_count = 0
    fail_pathes = []
    for case in test_cases_pathes:
        if test_case(lexer, parser, semant, pa4_semant, case):
            successful_count += 1
            print('Test case: {} pass :)'.format(case))
        else:
            fail_pathes.append(case)
            print('Test case: {} fail :('.format(case))
    print('Your score:\nPass: {}/{}\nFail:\n{}'.format(successful_count, count, '\n'.join(fail_pathes)))
 
 
if __name__ == '__main__':
    project_dir = sys.argv[1]
    if not os.path.isdir(project_dir):
        print('Input the root path of your cool project!')
        exit(1)
    test_pa4(project_dir)

```

## 提交要求

提交 `PA4` 文件夹的压缩文件（zip 格式）