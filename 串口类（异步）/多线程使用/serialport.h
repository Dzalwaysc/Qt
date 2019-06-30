#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QObject>
#include <QSerialPort>
#include <QTimer>
#include <QDebug>
#include <QFile>

class SerialPort : public QObject
{
    Q_OBJECT
public:
    explicit SerialPort(QObject *parent = nullptr);
    ~SerialPort();

public:
    QSerialPort *m_serial = nullptr;

    QTimer *m_recvTimer = nullptr;
    QTimer *m_sendTimer = nullptr;
    int m_recvCount;

    QByteArray m_storeNow = "";

    // 解包
    QByteArray recvDataFlow(QByteArray recvMsg);
    void parseRadioData(QByteArray recvMsg);

signals:
    void recvMsgChanged(QByteArray recvMsg);
    void serialPortRunning(bool isRunning);
    void serialPorterror(QString error);

public slots:
    // 打开和关闭关闭
    void onSerialPortRun(QByteArray port, qint32 baudRate, int recvTimeOut); // 打开串口
    void onSerialPortStop(); // 关闭串口

    // 读取和发送
    void onReadData(); // 读取文本数据
    void onSendData(const QByteArray sendMsg); // 发送数据

    // 定时发送
    void onAutoSendOpen(int interval); // 打开定时发送
    void onAutoSendStop(); // 关闭定时发送

    // 错误处理机制
    void onHandleError(QSerialPort::SerialPortError error); // 错误处理槽 m_serial -> onHandleError -> serialThread

    // 定时器信号槽
    void onRecvTimeout(); // 判断是否断连
    void onSendTimeout(); // 定时发送内容
};

#endif // SERIALPORT_H
