#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "workerthread.h"
#include "worker.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<WorkerThread>("io.workerThread", 1, 0, "Worker");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    qDebug()<<"main thread: "<<QThread::currentThreadId();
    return app.exec();
}
