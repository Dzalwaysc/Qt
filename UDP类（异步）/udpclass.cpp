#include "udpclass.h"

udpClass::udpClass(QObject* parent)
    :QObject (parent)
{
    udpSocket = new QUdpSocket(this);

    connect(udpSocket, &QUdpSocket::readyRead, this, &udpClass::processPendingData);

}

// 绑定(开始)，接受
void udpClass::bindSocket()
{
    udpSocket->bind(QHostAddress(m_localHostName), m_localPort);
}

void udpClass::closeSocket()
{
    udpSocket->close();
}

// 接受/发送
void udpClass::processPendingData()
{
    QByteArray datagram;
    while(udpSocket->hasPendingDatagrams()){
        // 接受数据
        datagram.resize(int(udpSocket->pendingDatagramSize()));
        udpSocket->readDatagram(datagram.data(), datagram.size());
    }
    m_recvMsg = datagram;
    emit recvMsgChanged();
    qDebug()<<datagram;
}

void udpClass::sendData()
{
    // udpSocket->bind(QHostAddress(m_localHostName), m_localPort);
    udpSocket->writeDatagram(m_response, QHostAddress(m_targetHostName), m_targetPort);
}

// 属性函数
QString udpClass::localHostName()
{
    return m_localHostName;
}

QString udpClass::targetHostName()
{
    return m_targetHostName;
}

int udpClass::localPort()
{
    return m_localPort;
}

int udpClass::targetPort()
{
    return m_targetPort;
}

QByteArray udpClass::response()
{
    return m_response;
}

QByteArray udpClass::recvMsg(){
    return m_recvMsg;
}

void udpClass::setlocalHostName(const QString& hostName)
{
    if(hostName == m_localHostName)
        return;
    m_localHostName = hostName;
    emit localHostNameChanged();
}

void udpClass::settargetHostName(const QString &hostName)
{
    if(hostName == m_targetHostName)
        return;
    m_targetHostName = hostName;
    emit targetHostNameChanged();
}

void udpClass::setlocalPort(int port)
{
    if(port == m_localPort)
        return;
    m_localPort = port;
    emit localPortChanged();
}

void udpClass::settargetPort(int port)
{
    if(port == m_targetPort)
        return;
    m_targetPort = port;
    emit targetPortChanged();
}

void udpClass::setresponse(const QByteArray &response)
{
    if(response == m_response)
        return;
    m_response = response;
    emit responseChanged();
}

void udpClass::setrecvMsg(const QByteArray &recvMsg){
    if(recvMsg == m_recvMsg)
        return;
    m_recvMsg = recvMsg;
    emit recvMsgChanged();
}
