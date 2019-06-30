#include "serialportthread.h"

SerialPortThread::SerialPortThread(QObject *parent) : QObject(parent)
{
    m_thread = new QThread;
    m_serialPort.moveToThread(m_thread);

    // 发送给SerialPort的信号)
    connect(this, &SerialPortThread::serialPortRun, &m_serialPort, &SerialPort::onSerialPortRun);
    connect(this, &SerialPortThread::serialPortStop, &m_serialPort, &SerialPort::onSerialPortStop);
    connect(this, &SerialPortThread::serialPortSend, &m_serialPort, &SerialPort::onSendData);
    connect(this, &SerialPortThread::serialPortAutoSendOpen, &m_serialPort, &SerialPort::onAutoSendOpen);
    connect(this, &SerialPortThread::serialPortAutoSendStop, &m_serialPort, &SerialPort::onAutoSendStop);

    // 接收来自SerialPort信号
    connect(&m_serialPort, &SerialPort::serialPortRunning, this, &SerialPortThread::onSerialPortRunning);
    connect(&m_serialPort, &SerialPort::recvMsgChanged, this, &SerialPortThread::onRecvMsgChanged);
    connect(&m_serialPort, &SerialPort::serialPorterror, this, &SerialPortThread::toQmlSerialportError);
    m_thread->start();
}

SerialPortThread::~SerialPortThread()
{
    if(!m_thread->isFinished()){ // 对应打开串口后，直接关闭
        emit serialPortStop();
        QThread::sleep(1);
        m_thread->quit();
        m_thread->wait();
    }else{ // 对应打开仿真后，按了停止，再关闭
        m_thread->start();
        emit serialPortStop();
        QThread::sleep(1);
        m_thread->quit();
        m_thread->wait();
    }
}

// 用户接口
void SerialPortThread::run(QByteArray port, qint32 baudRate, int recvTimeOut)
{
    // 如果线程已打开，则发射run信号
    if(m_thread->isRunning()){
        emit serialPortRun(port, baudRate, recvTimeOut);
        qDebug()<<"thread already start";
    }else{
        m_thread->start();
        emit serialPortRun(port, baudRate, recvTimeOut);
        qDebug()<<"thread start";
    }
}

void SerialPortThread::stop()
{
    if(m_thread->isRunning() && m_serialIsOpen){
        emit serialPortStop();
    }
}

void SerialPortThread::send(QByteArray sendMsg)
{
    if(m_thread->isRunning() && m_serialIsOpen){
        emit serialPortSend(sendMsg);
    }
}

void SerialPortThread::autoSendOpen(int interval)
{
    if(m_thread->isRunning() && m_serialIsOpen){
        emit serialPortAutoSendOpen(interval);
    }else{
        qDebug()<<"comm线程还没开启";
    }
}

void SerialPortThread::autoSendStop()
{
    if(m_thread->isRunning() && m_serialIsOpen){
        emit serialPortStop();
    }
}

// 串口是否已经打开  信号槽
void SerialPortThread::onSerialPortRunning(bool isRunning)
{
    m_serialIsOpen = isRunning;
    if(!m_serialIsOpen){
        m_thread->quit();
        m_thread->wait();
        qDebug()<<"serialPortThread stop";
    }
}


// 接收SerialPort信号的槽函数
void SerialPortThread::onRecvMsgChanged(QByteArray recvMsg)
{
    m_toQmlMsg = recvMsg;
    emit toQmlMsgChanged();
}

// qml属性
QString SerialPortThread::toQmlMsg()
{
    return m_toQmlMsg;
}
