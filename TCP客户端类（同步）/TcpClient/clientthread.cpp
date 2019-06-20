#include <QtNetwork>
#include <QDebug>
#include "clientthread.h"

ClientThread::ClientThread(QObject *parent)
    : QThread (parent),
      m_quit(false)
{
}

ClientThread::~ClientThread()
{
    m_mutex.lock();
    m_quit = true;
    m_mutex.unlock();
    wait();
}


// 开始关闭函数
void ClientThread::startFortune(const QString &hostName, quint16 port)
{
    QMutexLocker locker(&m_mutex);
    m_hostName = hostName;
    m_port = port;
    m_quit = false;
    if(!isRunning()){
        qDebug()<<"start";
        start();
    }
}

void ClientThread::run()
{
    m_mutex.lock();
    QString serverName = m_hostName;
    int serverPort = m_port;
    m_quit = false;
    m_mutex.unlock();
    int num = 0;
    const int Timeout = 5 * 1000;
    QTcpSocket socket;
    socket.connectToHost(serverName, serverPort, QTcpSocket::ReadWrite);
    if(!socket.waitForConnected(Timeout)){
        emit error(socket.error(), socket.errorString());
        qDebug()<<socket.error();
        return;
    }

    qDebug()<<"here";
    while(!m_quit){
        if(!socket.waitForReadyRead(5*1000)){
            emit error(socket.error(), socket.errorString());
            return;
        }
        QString fortune;
        fortune = socket.readAll();
        qDebug()<<fortune;
        qDebug()<<num++;
    }
    qDebug()<<"over";
    socket.disconnectFromHost();
}

void ClientThread::closeFortune()
{
    m_mutex.lock();
    m_quit = true;
    m_mutex.unlock();
}

// 属性函数
QString ClientThread::hostName()
{
    return m_hostName;
}

int ClientThread::port()
{
    return m_port;
}

void ClientThread::sethostName(const QString &hostName)
{
    if(hostName == m_hostName)
        return;
    m_hostName = hostName;
    emit hostNameChanged();
}

void ClientThread::setport(int port)
{
    if(port == m_port)
        return;
    m_port = port;
    emit portChanged();
}


// 发送函数
void ClientThread::sendResponse()
{
    return;
}
