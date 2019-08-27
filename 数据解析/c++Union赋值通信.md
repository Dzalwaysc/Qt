## c++使用Union中需要注意的地方

  直接用例子来进行阐述，假设当前的协议是
  
15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0
:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:
0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|

- 第一种解析方式:
	
	字节0-3为一个序列，字节4-5为一个序列，字节6-8为一个序列，字节9-10为一个序列，字节11-12为一个序列，字节13-15为一个序列
	
- 第二种解析方法

	全部直接都在一个序列中

```c++
#include <iostream>

struct MyStruct{
	union{
		unsigned short value;
		struct ST_TEST{
			unsigned char uc0: 1;
			unsigned char uc1: 1;
			unsigned char uc2: 1;
			unsigned char uc3: 1;
			unsigned char uc4: 1;
			unsigned char uc5: 1;
			unsigned char uc6: 1;
			unsigned char uc7: 1;
			unsigned char uc8: 1;
			unsigned char uc9: 1;
			unsigned char uc10: 1;
			unsigned char uc11: 1;
			unsigned char uc12: 1;
			unsigned char uc13: 1;
			unsigned char uc14: 1;
			unsigned char uc15: 1;
			}bits;
	}strWorld;
	
	union{
		unsigned short value;
		struct ST_TEST{
			unsigned char uc0: 4;
			unsigned char uc1: 2;
			unsigned char uc2: 3;
			unsigned char uc3: 2;
			unsigned char uc4: 2;
			unsigned char uc5: 3;
		}bits;
	}strWorld2;
	
	union{
		unsigned short value;
		struct ST_TEST{
			unsigned short uc0: 4;
			unsigned short uc1: 2;
			unsigned short uc2: 3;
			unsigned short uc3: 2;
			unsigned short uc4: 2;
			unsigned short uc5: 3;
		}bits;
	}strWorld3;
};

int main()
{
	MyStruct ms;
	memset(&ms, 0, sizeof(ms));
	
	// 本意: 给第13个字节赋1
	ms.strWorld.bits.uc12 = 1;
	ms.strWorld2.bits.uc4 = 2;
	ms.strWorld3.bits.uc4 = 2;
	
	printf("%x \n", ms.strWorld.value);  // 输出0x1000 -> 转换成二进制位: 000|10|00|000|00|0000
	printf("%x \n", ms.strWorld2.value); // 输出0x4000 -> 转换成二进制位: 010|00|00|000|00|0000
	printf("%x \n", ms.strWorld3.value); // 输出0x1000 -> 转换成二进制位: 000|01|00|000|00|0000
	
	// 发现若bits中使用unsigned char，是第15个字节被赋1
	// 即出现内存分配混乱的问题
	ms.strWorld2.bits.uc4 = 0;
	printf("%x \n", ms.strWorld2.value); // 输出0x0 -> 转换成二进制位: 000|00|00|000|00|0000
}
```
从上述的输出可以看出不同的赋值方式会造成不同的值，因此在核对通信协议的时候千万要注意这一方面

还有一点，其实上面第一种赋值的本意是错误的，因为我们的本意是让每一个byte都对应上，修改方法应该将`unsigned char`改成`unsigned short`
