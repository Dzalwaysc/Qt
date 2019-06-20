/******************************************************************************
 ** 通信: TCP客户端类(同步)
 **
 ** 注意:
 ** 1. #include <QSocket>类
 **    需要在.pro文件中加上一句:
 **            QT += network
 **
 ** 2. 所有文件路径不要带有中文名，否则报错
 ** 3. 该类目前没有主动发送功能
 **
 ** 介绍:
 **   该TCP客户端继承了QThread, 通过重写run()进行多线程操作, 由.start的方法激活run()
 **   在run()函数中创建Socket (在外部创建Socket m_socket, 然后在run中使用，报错: 不能在parent thread...)
 **   在run()函数中通过waitForConnected()进行阻塞式读取服务器信息
 **
 ** qml交互: 在qml生成该对象时具备
 **            2个属性  hostName 本地IP地址
 **                        port 本地端口号
 **
 **            3个方法  startFortune(const QString &hostName, quint16 port)  连接服务器(开启线程)
 **                    closeFortune()  断开连接(关闭线程)
 **                    sendResponse()  未完成
 **
 ** 使用:
 **  在main.cpp中  ->  #include "clientthread.h"
 **  在main.cpp中  ->  qmlRegisterType<ClientThread>("io.tcpClient", 1, 0, "Client");
 **  在main.qml中  ->  import io.tcpClient 1.0
 *******************************************************************************/

#ifndef ClientThread_H
#define ClientThread_H

#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QtNetwork>

class ClientThread : public QThread
{
    Q_OBJECT
    Q_PROPERTY(QString hostName READ hostName WRITE sethostName NOTIFY hostNameChanged)
    Q_PROPERTY(int port READ port WRITE setport NOTIFY portChanged)
public:
    ClientThread(QObject *parent = nullptr);
    ~ClientThread() override;

    Q_INVOKABLE void startFortune(const QString &hostName, quint16 port);
    Q_INVOKABLE void closeFortune();
    Q_INVOKABLE void sendResponse();
    void run() override;

signals:
    void error(int socketError, const QString &message);
    void hostNameChanged();
    void portChanged();

private:
    QString m_hostName;
    int m_port;
    QMutex m_mutex;
    bool m_quit;

    QTcpSocket m_socket;
public:
    QString hostName();
    int port();
    void sethostName(const QString &hostName);
    void setport(int port);
};

#endif // ClientThread_H
