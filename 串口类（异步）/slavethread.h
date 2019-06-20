/******************************************************************************
 ** 通信: 串口类(异步)
 **
 ** 注意:
 ** 1. #include <QSerialPort>
 **    需要在.pro文件中加上一句:
 **            QT += serialport
 **
 ** 2. 所有文件路径不要带有中文名，否则报错
 **
 ** 介绍:
 **   该串口使用异步的方式进行通信
 **   通过connect连接QSerialPort::readyRead信号和槽函数handleReadyRead -> 读取信息
 **   通过connect连接QserialPort::bytesWritten信号和槽函数handleBytesWritten ->验证发送是否完整
 **   通过connect连接QSerialPort::error信号和槽函数handleError -> 处理错误
 **
 **
 ** qml交互: 在qml生成该对象时具备
 **            3个属性  portName, response, recvMsg(只读)
 **            3个方法  satrtSlave() 打开串口
 **                    closeSlave() 关闭串口
 **                    sendResponse()  发送信息
 **
 ** 使用:
 **  在main.cpp中  ->  #include "slavethread.h"
 **  在main.cpp中  ->  qmlRegisterType<SlaveThread>("io.serialport", 1, 0, "Comm");
 **  在main.qml中  ->  import io.serialport 1.0
 *******************************************************************************/

#ifndef SLAVETHREAD_H
#define SLAVETHREAD_H

#include <QThread>
#include <QSerialPort>

class SlaveThread : public QThread
{
    Q_OBJECT

    Q_PROPERTY(QString portName READ portName WRITE setportName NOTIFY portNameChanged)
    Q_PROPERTY(QByteArray response READ response WRITE setresponse NOTIFY responseChanged)
    Q_PROPERTY(QByteArray recvMsg READ recvMsg NOTIFY recvMsgChanged)

public:
    explicit SlaveThread(QObject *parent = nullptr);
    ~SlaveThread() override;

    Q_INVOKABLE void startSlave();
    Q_INVOKABLE void closeSlave();
    Q_INVOKABLE void sendResponse();

private slots:
    void handleReadyRead();
    void handleError(QSerialPort::SerialPortError error);
    void handleBytesWritten(qint64 bytes);

private:
    QSerialPort m_serial;

    QString m_portName;
    QByteArray m_response;
    QByteArray m_recvMsg;
    qint64 m_bytesWritten = 0;
signals:
    // 属性信号
    void portNameChanged();
    void responseChanged();
    void recvMsgChanged();

public:
    // 属性函数
    QString portName();
    void setportName(const QString &portName);
    QByteArray response();
    void setresponse(const QByteArray &response);
    QByteArray recvMsg();
};

#endif // SLAVETHREAD_H
