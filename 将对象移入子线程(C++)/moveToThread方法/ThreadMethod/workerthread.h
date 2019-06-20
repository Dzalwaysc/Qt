#ifndef WORKERTHREAD_H
#define WORKERTHREAD_H

#include <QObject>
#include <QtCore>
#include "worker.h"

class WorkerThread : public QObject
{
    Q_OBJECT
public:
    explicit WorkerThread(QObject *parent = nullptr);
    ~WorkerThread();
    QThread* thread;
    Worker worker;
    Q_INVOKABLE void run();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void close();

signals:
    void startWorker();
    void stopWorker();

};

#endif // WORKERTHREAD_H
