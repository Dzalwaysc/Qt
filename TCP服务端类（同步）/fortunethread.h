/************************************************************
 * FortuneThread的子类，每当来一个客户端连接，就生成一个
************************************************************/

#ifndef FORTUNETHREAD_H
#define FORTUNETHREAD_H

#include <QThread>
#include <QTcpSocket>
#include <QMutex>

class FortuneThread : public QThread
{
    Q_OBJECT

public:
    FortuneThread(int socketDescriptor, const QString &fortune, QObject *parent);
    void run() Q_DECL_OVERRIDE;
    void killThread();

signals:
    void error(QTcpSocket::SocketError socketError);

private:
    int socketDescriptor;
    QString text;
    QMutex m_mutex;
    bool m_quit;
};

#endif // FORTUNETHREAD_H
