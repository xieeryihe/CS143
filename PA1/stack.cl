--链表节点类
class LinkNode{
    element : String;
    next : LinkNode;
    getElement():String{
        element
    };
    getNext():LinkNode{
        next
    };
    setElement(s:String):String{
        element <- s
    };
    setNext(node:LinkNode):LinkNode{
        next <- node
    };
};

--栈类
class Stack inherits IO{
    --本栈是带头结点的链表，一个链表总有head节点且非空
    head : LinkNode;

    --初始化
    init():Object{
        {
            if isvoid head then{
                head <- new LinkNode;
                head.setElement("head");
            }else false 
            fi;
        }
    };

    --返回head元素
    getHead():LinkNode{
        head
    };

    isEmpty():Bool{
        let b:Bool,temp:LinkNode in {
            temp <- head.getNext();
            if isvoid temp then{
                b <- true;
            }else {
                b <- false;
            }
            fi;
            b; -- 返回值
        }
    };

    --返回栈顶元素
    getTop():String{
        let temp:LinkNode,s:String in{
            temp <- head.getNext();
            s <- temp.getElement();
            s;
        }
    };

    --出栈
    pop():String{
        let old_top:LinkNode,new_top:LinkNode,s:String in {
            old_top <- head.getNext();
            if not isvoid old_top then{
                new_top <- old_top.getNext();
                head.setNext(new_top);
                s <- old_top.getElement();--原栈顶的元素
            }else false
            fi;
            s;
        }
    };

    --入栈
    push(s:String):LinkNode{
        let old_top:LinkNode,new_top:LinkNode <- new LinkNode in {
            old_top <- head.getNext();
            new_top.setElement(s);
            new_top.setNext(old_top);
            head.setNext(new_top);
            head;
        }
    };

    --描述的是"d"操作，打印整个栈
    print():Object{
        let temp:LinkNode,s:String in {
            temp <- head.getNext();
            while not isvoid temp loop{
                s <- temp.getElement();
                out_string(s);
                out_string("\n");
                temp <- temp.getNext();
            }pool;
        }
    };

    --描述的是"+"操作
    --转换的类是A2I，方法为c2i,i2c数字字符和数字之间的转换
    --方法a2i,i2a是字符串和数字之间的转化
    add():Object{
        let tool:A2I <- new A2I,
        x:Int,          y:Int,
        s1:String,      s2:String,s:String
        in
        {
            s1 <- pop();
            s2 <- pop();
            x <- tool.a2i(s1);
            y <- tool.a2i(s2);
            s <- tool.i2a(x+y);
            push(s);
        }
    };
    
    --"s"操作，交换最顶上的两个元素
    exchange():Object{
        let s1:String,s2:String in {
            s1 <- pop();
            s2 <- pop();
            push(s1);
            push(s2);
        }
    };

};

class Main inherits IO{
    
    main():Object{
        let ch:String,flag:Int <- 1,stack:Stack in
        {
            stack <- new Stack;
            stack.init();

            -- 开始主循环            
            
            while 0 < flag loop{
                out_string(">");
                ch <- in_string();
                if ch = "x" then {
                    flag <- 0;
                }else if ch = "d" then{
                    stack.print();
                }else if ch = "e" then{
                    -- 三种情况操作
                    let opt:String in {
                        opt <- stack.pop();
                        if opt = "+" then{
                            stack.add();
                        }else if opt = "s" then{
                            stack.exchange();
                        }else false
                        fi fi;
                    };

                }else{
                    stack.push(ch);
                }
                fi fi fi;
                --out_string("\n");
            }pool;
        }
    };
};