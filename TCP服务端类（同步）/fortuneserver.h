/******************************************************************************
 ** 通信: TCP服务器类(异步)
 **
 ** 注意:
 ** 1. #include <QSocket>类
 **    需要在.pro文件中加上一句:
 **            QT += network
 **
 ** 2. 所有文件路径不要带有中文名，否则报错
 **
 ** 3. 该类的closeListen()函数，即停止监听还是有问题
 **
 ** 4. 该类目前没有主动发送功能和主动断开连接功能
 **
 ** 
 ** 介绍:
 **   该TCP服务端，通过重写incomingConnection函数，令服务器socket为异步操作
 **                       在incomingConnection中，每当来一个客户端连接，就生成一个线程对应该客户端的通信
 **   其中，服务器具备操作为: 开启服务器，监听（异步）
 **        每个线程具备操作为: 读取客户端到来的信息（同步）
 **
 **   主类FortuneServer重写incomingConnection函数，为每个连接的客户端安排一个读取线程
 **   子类FortuneThread在run中，通过waitForReadyRead()对进行同步读取数据
 **
 **
 **
 ** qml交互: 在qml生成该对象时具备
 **            2个属性  hostName 本地IP地址
 **                        port 本地端口号
 **
 **            2个方法  startListen()  开始监听
 **                    closeSlave()   停止监听
 **
 ** 使用:
 **  在main.cpp中  ->  #include "fortuneserver.h"
 **  在main.cpp中  ->  qmlRegisterType<FortuneServer>("io.tcpServer", 1, 0, "Server");
 **  在main.qml中  ->  import io.tcpServer 1.0
 *******************************************************************************/

#ifndef FORTUNESERVER_H
#define FORTUNESERVER_H

#include <QTcpServer>
#include <QHostAddress>
#include "fortunethread.h"
class FortuneServer : public QTcpServer
{
    Q_OBJECT
    Q_PROPERTY(QString hostName READ hostName WRITE sethostName NOTIFY hostNameChanged)
    Q_PROPERTY(int port READ port WRITE setport NOTIFY portChanged)

public:
    FortuneServer(QObject *parent = nullptr);

protected:
    void incomingConnection(qintptr socketDescriptor) Q_DECL_OVERRIDE;

public:
    Q_INVOKABLE void startListen();
    Q_INVOKABLE void closeListen();
    int m_port;
    QString m_hostName;

signals:
    void hostNameChanged();
    void portChanged();

public:
    QString hostName();
    int port();
    void sethostName(const QString &hostName);
    void setport(int port);
};

#endif // FORTUNESERVER_H
