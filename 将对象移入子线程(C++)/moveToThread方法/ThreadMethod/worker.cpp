#include "worker.h"

Worker::Worker(QObject *parent) : QObject(parent)
{
}

Worker::~Worker()
{
    qDebug()<<"worker delete";
}
