#include "workerthread.h"

WorkerThread::WorkerThread(QObject *parent) : QObject(parent)
{
    thread = new QThread();
    // 将worker移入子线程
    worker.moveToThread(thread);

    // 将worker的方法与WorkerThread的信号连接，供外部使用
    QObject::connect(this, SIGNAL(startWorker()), &worker, SLOT(onStart()));
    QObject::connect(this, &WorkerThread::stopWorker, &worker, &Worker::onStop);

    // 打开线程
    thread->start();
}

WorkerThread::~WorkerThread()
{
    QObject::connect(thread, &QThread::finished, &worker ,&WorkerThread::deleteLater);
    thread->quit();
    thread->wait();

    qDebug()<<"workerThread delete";
}
void WorkerThread::run()
{
    if(thread->isFinished()){
        thread->start();
    }
    emit startWorker();
}

void WorkerThread::stop()
{
    emit stopWorker();
}

void WorkerThread::close()
{
    emit stopWorker();
    thread->quit();
    thread->wait();
    if(thread->isFinished()){
        qDebug()<<"Thread is finished";
    }
}
