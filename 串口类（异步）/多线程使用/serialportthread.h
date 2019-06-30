/*********************************************************
** 串口类: SerialPort
** 线程类: SerialPortThread
** 暴露给外部的接口类: SerialPortThread
**
**************** 信号流 ****************************
** 1.开始:
**  run     SerialPortThread:
**      往串口发送 -> 开始信号
**
**  onSerialPortRun    SerialPort:
**       如果打开串口成功，往线程发送串口已经打开信号
**       否则发送串口已关闭信号
**
** 2.关闭:
**  stop    SerialPortThread:
**      往串口发送 -> 关闭信号
**  onSerialPortStop    SerialPort:
**      关闭所有定时器和串口
**      发送串口已关闭信号
**
** 3.发送:
**  send    SerialPortThread:
**       往串口发送 -> 发送信号
**  onSendData         SerialPort:
**       发送内容
**
** 4.自动发送:
**  autoSendOpen        SerialPortThread:
**       往串口发送 -> 自动发送打开
**  onAutoSendStop      SerialPort
**       打开自动发送
**  autoSendStop        SerialPortThread:
**       往串口发送 -> 自动发送关闭
**  onAutoSendStop      SerialPort
**       关闭自动发送
****************** 槽流 ***************************
** 1.接受信息槽:
**   recvMsgChanged    SerialPort
**      当接受到的数据流完整时，发送到Thread
**   onRecvMsgChanged  SerialPortThread:
**      发送信号给qml
**
**  SerialPort中使用该信号的函数:
**     parseRadioData
**
** 2. 串口是否开启信号槽:
**   serialPortRunning  SerialPort
**     如果串口开启了发送true，否则发送false
**   onSerialPortRunning    SerialPortThread
**     如果串口已关闭，则关闭线程，否则直接return
**
**   SerialPort使用该信号的函数
**     onSerialPortRun
**     onSerialPortStop
*********************************************************/

#ifndef SERIALPORTTHREAD_H
#define SERIALPORTTHREAD_H

#include <QObject>
#include <QThread>
#include <serialport.h>

class SerialPortThread : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString toQmlMsg READ toQmlMsg NOTIFY toQmlMsgChanged)

public:
    explicit SerialPortThread(QObject *parent = nullptr);
    ~SerialPortThread();

public:
    SerialPort m_serialPort;
    bool m_serialIsOpen = false;
    QThread *m_thread;

    // 外部使用的方法
    Q_INVOKABLE void run(QByteArray port, qint32 baudRate, int recvTimeOut);
    Q_INVOKABLE void stop();
    Q_INVOKABLE void send(QByteArray sendMsg);
    Q_INVOKABLE void autoSendOpen(int interval);
    Q_INVOKABLE void autoSendStop();

// 发送给SerialPort类的信号
signals:
    void serialPortRun(QByteArray port, qint32 baudRate, int recvTimeOut);
    void serialPortStop();
    void serialPortSend(QByteArray sendMsg);
    void serialPortAutoSendOpen(int interval);
    void serialPortAutoSendStop();

// 接收SerialPort信号的信号槽
public slots:
    void onRecvMsgChanged(QByteArray recvMsg);
    void onSerialPortRunning(bool isRunning);

 // qml属性接口
public:
    QString m_toQmlMsg;
    QString toQmlMsg();
signals:
    void toQmlMsgChanged();
    void toQmlSerialportError(QString error);
};

#endif // SERIALPORTTHREAD_H
