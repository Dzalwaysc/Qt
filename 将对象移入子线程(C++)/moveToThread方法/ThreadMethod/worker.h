/***********************************************************
 ** 将定时器也放入子线程
 ** 线程类 -> WorkerThread
 ** 目标类 -> Worker
 ** 供给外部使用的类 -> WorkerThread
 **
 ** 在WorkerThread中，通过moveToThread将Worker移入子线程
 ** 然后WorkerThread发射信号，Worker使用槽函数响应信号
 **
 ** 这里我在onStart()中赋值m_timer，而不是在构造函数中赋值的原因是:
 ** 在构造函数中赋值报错:
 **     QObject::startTimer: Timers cannot be started from another thread
 **
 ** 过程:
 **   1.将Worker中的方法变成槽函数
 **   2.在WorkerThread中，通过moveToThread将Worker移入子线程
 **   3.为了能够使用Worker中的方法，WorkerThread创建对应的信号和方法
 **   4.连接信号和槽
 **
 ** Worker方法的使用流:
 **   WorkerThread -> run(): emit startWorker() -> Worker -> slot: onStart()
***********************************************************/
#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <QtCore>

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(QObject *parent = nullptr);
    ~Worker();

    QTimer *m_timer;
signals:

public slots:
    void onStart(){
        m_timer = new QTimer;
        m_timer->start(500);
        connect(m_timer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    }
    void onStop(){
        m_timer->stop();
    }
    void onTimeout(){
        qDebug()<<"Worker: "<<QThread::currentThreadId();
    }
};

#endif // WORKER_H
