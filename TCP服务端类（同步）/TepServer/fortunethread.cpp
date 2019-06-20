#include "fortunethread.h"
#include <QtNetwork>
FortuneThread::FortuneThread(int socketDescriptor, const QString &fortune, QObject *parent)
    : QThread (parent), socketDescriptor(socketDescriptor), text(fortune)
{
}

void FortuneThread::run()
{
    m_mutex.lock();
    m_quit = false;
    m_mutex.unlock();

    QTcpSocket tcpSocket;
    if(!tcpSocket.setSocketDescriptor(socketDescriptor)){
        emit error(tcpSocket.error());
        qDebug()<<"setError";
        return;
    }

    // 输出客户端IP地址和端口号
    qDebug()<<tcpSocket.peerAddress().toIPv4Address();
    qDebug()<<tcpSocket.peerPort();

    // 如果客户端失去连接或者m_quit=false则线程结束
    while(tcpSocket.state() == QAbstractSocket::ConnectedState && m_quit == false){
        if(!tcpSocket.waitForReadyRead()){
            qDebug()<<"waitForReadyRead Timeout";
        }
        QByteArray request = tcpSocket.readAll();

        qDebug()<< QString::number(tcpSocket.peerPort()) + "read: " + request;
    }
    tcpSocket.disconnectFromHost();
    qDebug()<<"toDisconnect";
    tcpSocket.waitForDisconnected();
}

void FortuneThread::killThread()
{
    qDebug()<<"toKillThread";
    m_mutex.lock();
    m_quit = true;
    m_mutex.unlock();
    wait();
}
