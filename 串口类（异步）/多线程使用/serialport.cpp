#include "serialport.h"

SerialPort::SerialPort(QObject *parent) : QObject(parent)
{
}

SerialPort::~SerialPort()
{
    onSerialPortStop();
    qDebug()<<"serial port is finished";
}

// 打开和关闭串口函数
void SerialPort::onSerialPortRun(QByteArray port, qint32 baudRate, int recvTimeOut)
{
    // 开启串口
    if(m_serial == nullptr){
        m_serial = new QSerialPort(this);
    }
    m_serial->setPortName(port);
    m_serial->setBaudRate(baudRate);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setStopBits(QSerialPort::OneStop);
    m_serial->setParity(QSerialPort::NoParity);
    connect(m_serial, &QSerialPort::errorOccurred, this, &SerialPort::onHandleError);

    if( !m_serial->open(QIODevice::ReadWrite)){
        emit serialPortRunning(false); // 告诉线程，打开串口失败
        return;
    }
    connect(m_serial, &QSerialPort::readyRead, this, &SerialPort::onReadData);

    // 开启定时器
    if(m_recvTimer == nullptr){
        m_recvTimer = new QTimer(this);
        m_recvTimer->start(recvTimeOut);
        connect(m_recvTimer, &QTimer::timeout, this, &SerialPort::onRecvTimeout);
    }else{
        m_recvTimer->start(recvTimeOut);
    }

    // 发送给线程信号
    emit serialPortRunning(true);
}

void SerialPort::onSerialPortStop()
{
    if(m_recvTimer != nullptr && m_recvTimer->isActive()){
        m_recvTimer->stop();
        qDebug()<<"m_recvTimer stop";
    }
    if(m_sendTimer != nullptr && m_sendTimer->isActive()){
        m_sendTimer->stop();
        qDebug()<<"m_sendTimer stop";
    }
    if(m_serial->isOpen()){
        m_serial->close();
        qDebug()<<"m_serial stop";
    }
    // 发送给线程信号
    emit serialPortRunning(false);
}

// 接收和发送信息函数
void SerialPort::onReadData()
{
    QByteArray recvMsg = m_serial->readAll();
    m_recvCount += 1;

    if(m_serial->portName() == "COM1"){
         parseRadioData(recvMsg);
    }
}

void SerialPort::onSendData(const QByteArray sendMsg)
{
    const qint64 bytes = m_serial->write(sendMsg);

    if(bytes == -1){
        qDebug()<<tr("Failed to write the data to port %1, error %2")
                  .arg(m_serial->portName())
                  .arg(m_serial->errorString());
    }else if(bytes != sendMsg.size()){
        qDebug()<<tr("Failed to write the all data to port %1, error %2")
                  .arg(m_serial->portName())
                  .arg(m_serial->errorString());
    }
}

// 定时发送
void SerialPort::onAutoSendOpen(int interval)
{
    if(m_sendTimer == nullptr){
        m_sendTimer = new QTimer;
        m_sendTimer->start(interval);
        connect(m_sendTimer, &QTimer::timeout, this, &SerialPort::onSendTimeout);
    }else{
        m_sendTimer->start(interval);
    }
}

void SerialPort::onAutoSendStop()
{
    if(m_sendTimer != nullptr){
        m_sendTimer->stop();
    }
}

// 错误处理槽
void SerialPort::onHandleError(QSerialPort::SerialPortError error)
{
    qDebug()<<error;
    emit serialPorterror(m_serial->errorString());
}

// 定时器信号槽
void SerialPort::onRecvTimeout()
{
    if (m_recvCount == 0){
        qDebug()<<"连接中断";
    }else{
        m_recvCount = 0;
    }

}

void SerialPort::onSendTimeout()
{
    onSendData("hello");
}


// 数据流接收  如果打的包数据已经完整，这Terminate不为空，否则Terminate为空
QByteArray SerialPort::recvDataFlow(QByteArray recvMsg)
{
    QByteArray Terminate; Terminate.clear();
    if( -1 != m_storeNow.indexOf("$") ){ // 现在打的包有头了

        if(-1 != recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ //含有$，且含有#
            int n = recvMsg.indexOf("$");
            int m = recvMsg.indexOf("#");

            if( n<m ){ // #在$后面 本次内容即完整的一段
                Terminate = recvMsg.mid(n, m-n+1); // 打包完整，走你
                m_storeNow.clear();
            }else if( n>m ){ // #在$前面，本次打包内容有 正在打包的尾 和下一次要打包的头
                m_storeNow += recvMsg.left(m+1); // 加上尾OK 这次打包完整
                Terminate = m_storeNow; // 把包包放到流通盒中
                m_storeNow.clear(); // 清空一下包包
                QByteArray newMsg = recvMsg.right(recvMsg.size() - n); // 把$后面的内容放到下一个要打的包中
                m_storeNow = newMsg; // 把下一个包的内容到现在这个包里，继续等待快递给数据把。
            }
        }

        else if(-1 != recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 仅含有$
            // 新的开始, 把正在打的包刷新一下
            m_storeNow.clear();
            int n = recvMsg.indexOf("$"); // 找到$的位置
            m_storeNow = recvMsg.right( recvMsg.size()-n ); // 把$之后的内容放到包中
        }

        else if(-1 == recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 仅仅含有#
            // 说明快递送来了最后的零件
            int m = recvMsg.indexOf("#");
            m_storeNow += recvMsg.left(m+1); // 内容补充完整
            Terminate = m_storeNow; // 把包包放到流通盒里中
            m_storeNow.clear(); // 清空一下包包
        }

        else if(-1 == recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 即不含$，且不含#
            m_storeNow += recvMsg; //把这次快递过来的东西放到包包里去
        }
    }

    else if( -1 == m_storeNow.indexOf("$") ){ //现在的包包要么是空包，要么打包错误
        m_storeNow.clear(); // 既然是空包那就刷新一次，如果是错误包，那么更要刷新一次了

        if(-1 != recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 含有$，且含有#
            int n = recvMsg.indexOf("$");
            int m = recvMsg.indexOf("#");
            if( n<m ){ // #在$后面，本次内容即为完整的一段
                Terminate = recvMsg.mid(n, m-n+1); // 打包完整，走你
            }else if( n>m ){ // #在$后面，包包为空，所以只需要截取$后的内容就OK了
                m_storeNow = recvMsg.right( recvMsg.size()-n );
            }
        }

        else if(-1 != recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 仅含有$
            int n = recvMsg.indexOf("$"); //找到$的位置
            m_storeNow = recvMsg.right( recvMsg.size()-n ); //把$之后的内容放到包里
        }

        else if(-1 == recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 仅含有#
            // 说明快递送来了最后的零件
            // 但是正在打包的包包没有头， 所以这次快递拒绝接受
        }

        else if(-1 == recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 即不含$，且不含#
            // 说明快递送来了中间的零件
            // 但是正在打包的包包没有头，所以这次快递拒绝接受
        }
    }
    return Terminate;
}

// 解包
void SerialPort::parseRadioData(QByteArray recvMsg)
{
    QByteArray Terminate = recvDataFlow(recvMsg);
    if(!Terminate.isEmpty()){
        qDebug()<<Terminate;
        emit recvMsgChanged(Terminate);
    }
}
