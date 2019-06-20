/**************************
**
** #include <QSerialPort>
** 需要在.pro文件中加上一句:
**        QT += serialport
**
***************************/

#include "slavethread.h"

#include <QTime>
#include <QDebug>

SlaveThread::SlaveThread(QObject *parent) :
    QThread(parent)
{
}

SlaveThread::~SlaveThread()
{
}

// 开始关闭函数
void SlaveThread::startSlave()
{
    m_serial.setPortName(m_portName);
    m_serial.setBaudRate(QSerialPort::Baud9600);
    m_serial.setDataBits(QSerialPort::Data8);
    m_serial.setStopBits(QSerialPort::OneStop);
    m_serial.setParity(QSerialPort::NoParity);

    if(!m_serial.open(QIODevice::ReadWrite)){
        qDebug()<<tr("serial open failed %1").arg(m_portName);
        return;
    }
    connect(&m_serial, &QSerialPort::readyRead, this, &SlaveThread::handleReadyRead);
    connect(&m_serial, &QSerialPort::bytesWritten, this, &SlaveThread::handleBytesWritten);
    connect(&m_serial,
            static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
            this, &SlaveThread::handleError);
}

void SlaveThread::closeSlave()
{
    m_serial.close();
}

// property函数
QString SlaveThread::portName()
{
    return m_portName;
}

QByteArray SlaveThread::response()
{
    return m_response;
}

QByteArray SlaveThread::recvMsg()
{
    return m_recvMsg;
}

void SlaveThread::setportName(const QString &portName)
{
    if(portName == m_portName)
        return;
    m_portName = portName;
    emit portNameChanged();
}

void SlaveThread::setresponse(const QByteArray &response)
{
    if(m_response == response)
        return;
    m_response = response;
    emit responseChanged();
}

// 读写处理函数
void SlaveThread::handleReadyRead()
{
    m_recvMsg = m_serial.readAll();
    qDebug()<<m_recvMsg;
    emit recvMsgChanged();
}

void SlaveThread::handleBytesWritten(qint64 bytes)
{
    m_bytesWritten += bytes;
    if(m_bytesWritten == m_response.size()){
        m_bytesWritten = 0;
        qDebug()<<tr("SerialData Successfully sent to port %1")
                  .arg(m_serial.portName());
    }
}

void SlaveThread::sendResponse()
{
    //write response
    const QByteArray responseData = m_response;
    const qint64 bytes = m_serial.write(responseData);
    if(bytes == -1){
        qDebug()<<tr("Failed to write the data to port %1, error %2")
                  .arg(m_serial.portName())
                  .arg(m_serial.errorString());
    }else if(bytes != m_response.size()){
        qDebug()<<tr("Failed to write the all data to port %1, error %2")
                  .arg(m_serial.portName())
                  .arg(m_serial.errorString());
    }
}

// 处理错误
void SlaveThread::handleError(QSerialPort::SerialPortError serialPortError)
{
    qDebug()<<serialPortError;
}
