# 现象描述
下位机北斗发送过来的信息，是存在unsigned char中，然后发送过来，上位机用QByteArray接收到了数据。但我通过`char *data = QByteArray.data()`，使用char对数据解析的时候发现数据丢失了。

##传进来的数据

```c++
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    unsigned char buf[] = {0x24, 0x54, 0x58, 0x58, 0x58,
                  0x00, 0x52,
                  0x05, 0xd4, 0x60,
                  0x60,
                  0x05, 0xd4, 0x69,
                  0x00, 0x00,
                  0x01, 0xf0,
                  0xa4, 0x30, 0x20, 0x34, 0x20, 0x30, 0x20, 0x30,
                  0x20, 0x30, 0x20, 0x30, 0x20, 0x30, 0x20, 0x30,
                  0x20, 0x30, 0x20, 0x30, 0x20, 0x30, 0x20, 0x34,
                  0x34, 0x38, 0x20, 0x30, 0x20, 0x30, 0x20, 0x30,
                  0x20, 0x30, 0x20, 0x30, 0x20, 0x30, 0x20, 0x30,
                  0x20, 0x2d, 0x32, 0x38, 0x36, 0x33, 0x33, 0x31,
                  0x31, 0x35, 0x34, 0x20, 0x2d, 0x32, 0x38, 0x36,
                  0x33, 0x33, 0x31, 0x31, 0x35, 0x34,
                  0x00, 0x7a};

    char* chBuf = reinterpret_cast<char*>(buf);

    QByteArray recvMsg(chBuf, sizeof(buf));
    qDebug()<<recvMsg;
    qDebug()<<recvMsg.toHex();
    return a.exec();
}
输出: "$TXXX\x00R\x05\xD4``\x05\xD4i\x00\x00\x01\xF0\xA4""0 4 0 0 0 0 0 0 0 0 0 448 0 0 0 0 0 0 0 -286331154 -286331154\x00z"
输出: "2454585858005205d4606005d469000001f0a4302034203020302030203020302030203020302030203434382030203020302030203020302030202d323836333331313534202d323836333331313534007a"
```

## 解析数据

采用下面这个函数对recvMsg进行数据解析

```c++
QByteArray gpsExtractRecvData1(QByteArray Terminate)
{
    // 数据流的形式接收信息
    char *data = Terminate.data();
    // 主要内容长度
    char hl,ll;
    hl = *(data+16);
    ll = *(data+17);
    int bytes = hl<<8 | ll;
    int size = (bytes-1) / 8;
	
    qDebug("hl: %x, ll: %x", hl, ll);
    qDebug("bytes: %d", bytes);
    qDebug("size: %d\n", size);
	
    // 主要内容
    char buf[size+1]; buf[size]='\0';
    for(int i=0; i<size; i++) buf[i] = *(data+19+i);

    QByteArray FinalMsg(buf); // 去掉北斗协议，获取报文内容
    return  FinalMsg;
}
输出: hl: 1, ll: fffffff0
输出: bytes: -16
输出：size: -2

这显然是不对的，通过十六进制转十进制，发现0x01 0xf0为496
```

## 解决方法
- 上面的问题中，可以看到输出的`bytes = -16`，
- 这显然是因为，我接的时候没有考虑到符号的影响
- 对面发送来的是unsigned char，而我处理的时候却用char去处理，那么就导致了我在解析的时候最高位成为了符号位

```c++
QByteArray gpsExtractRecvData1(QByteArray Terminate)
{
    // 数据流的形式接收信息
    unsigned char *data = reinterpret_cast<unsigned char*>(Terminate.data());
    // 主要内容长度
    unsigned char hl,ll;
    hl = *(data+16);
    ll = *(data+17);
    int bytes = hl<<8 | ll;
    int size = (bytes-1) / 8;
    qDebug("hl: %x, ll: %x", hl, ll);
    qDebug("bytes: %d", bytes);
    qDebug("size: %d\n", size);

    // 主要内容
    unsigned char buf[size+1]; buf[size]='\0';
    for(int i=0; i<size; i++) buf[i] = *(data+19+i);

    QByteArray FinalMsg(reinterpret_cast<char*>(buf)); // 去掉北斗协议，获取报文内容
    return  FinalMsg;
}
输出: hl: 1, ll: f0
输出: bytes: 496
输出: size: 61

这样输出就正确了，ok！
```

- 这个时候我的想法是，我就算用char去获取内容了，但是我用unsigned int读bytes
不就好了吗？ 
- 这么麻烦干嘛，所以我在上面那个错误代码的基础上，就仅仅改了
 `unsigned in bytes = hl<<8 | ll`
- 发现结果还是上面的那个错误

## 错误解析
- 下位机发来的是0x01 0xf0，可以看到如果我用错误的代码去解析
- 即用char去读，那么读出来的是0x01, 0xfffffff0
- 这显然是不对的，因为这个时候可以看到此时认为最高位是负数了，所以给最高位赋了f