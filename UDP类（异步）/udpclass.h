/******************************************************************************
 ** 通信: 网络类(UDP)
 **
 ** 注意:
 ** 1. #include <QUdpSocket>
 **    需要在.pro文件中加上一句:
 **            QT += network
 **
 ** 2. 所有文件路径不要带有中文名，否则报错
 ** 
 ** 介绍:
 **   该UDP类为异步通信
 **   通过connect连接QSerialPort::readyRead信号和槽函数processPendingData() -> 读取信息
 **
 ** qml交互: 在qml生成该对象时具备
 **            6个属性  localHostName(本地IP地址), localPort(本地端口号)
 **                    targetHostName(目标IP地址), targetPort(目标端口号)
 **                    response(需要发送的内容), recvMsg(接收到的内容)
 **            3个方法  bindSocket()  绑定本地套接字
 **                    closeSocket() 关闭本地套接字
 **                    sendData()    发送信息
 **
 ** 使用:
 **  在main.cpp中  ->  #include "udpclass.h"
 **  在main.cpp中  ->  qmlRegisterType<udpClass>("io.udp", 1, 0, "Udp");
 **  在main.qml中  ->  import io.udp 1.0
 *******************************************************************************/

#ifndef UDPCLASS_H
#define UDPCLASS_H

#include <QObject>
#include <QUdpSocket>

class udpClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString localHostName READ localHostName WRITE setlocalHostName NOTIFY localHostNameChanged)
    Q_PROPERTY(int localPort READ localPort WRITE setlocalPort NOTIFY localPortChanged)
    Q_PROPERTY(QString targetHostName READ targetHostName WRITE settargetHostName NOTIFY targetHostNameChanged)
    Q_PROPERTY(int targetPort READ targetPort WRITE settargetPort NOTIFY targetPortChanged)
    Q_PROPERTY(QByteArray response READ response WRITE setresponse NOTIFY responseChanged)
    Q_PROPERTY(QByteArray recvMsg READ recvMsg WRITE setrecvMsg NOTIFY recvMsgChanged)

public:
    udpClass(QObject* parent = nullptr);
    void processPendingData();
    Q_INVOKABLE void bindSocket();
    Q_INVOKABLE void closeSocket();
    Q_INVOKABLE void sendData();
private:
    QUdpSocket* udpSocket = nullptr;
    QString m_localHostName;
    int m_localPort;
    QString m_targetHostName;
    int m_targetPort;
    QByteArray m_response;
    QByteArray m_recvMsg;

public:
    QString localHostName();
    int localPort();
    QString targetHostName();
    int targetPort();
    QByteArray response();
    QByteArray recvMsg();

    void setlocalHostName(const QString &hostName);
    void settargetHostName(const QString &hostName);
    void setlocalPort(int port);
    void settargetPort(int port);
    void setresponse(const QByteArray &response);
    void setrecvMsg(const QByteArray &recvMsg);
signals:
    void localHostNameChanged();
    void targetHostNameChanged();
    void localPortChanged();
    void targetPortChanged();
    void responseChanged();
    void recvMsgChanged();
};

#endif // UDPCLASS_H
