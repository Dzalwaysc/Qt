#include "fortuneserver.h"
#include <stdlib.h>

FortuneServer::FortuneServer(QObject *parent)
    : QTcpServer (parent)
{
}

void FortuneServer::incomingConnection(qintptr socketDescriptor)
{
    FortuneThread *thread = new FortuneThread(socketDescriptor, "hello", this);
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}

void FortuneServer::startListen()
{
    qDebug() <<m_hostName;
    QHostAddress address(m_hostName);
    this->listen(address, m_port);
    qDebug()<<"start listen";
}

void FortuneServer::closeListen()
{
    //threadOne->killThread();
    this->close();
    this->deleteLater();
}

QString FortuneServer::hostName()
{
    return m_hostName;
}

int FortuneServer::port()
{
    return m_port;
}

void FortuneServer::sethostName(const QString &hostName)
{
    if(hostName == m_hostName)
        return;
    m_hostName = hostName;
    emit hostNameChanged();
}

void FortuneServer::setport(int port)
{
    if(port == m_port)
        return;
    m_port = port;
    emit portChanged();
}
