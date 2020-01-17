#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include <QCommandLineParser>
#include <QDir>
#include <QStandardPaths>

#include "backend.hpp"

static Backend *backend;
static QObject *getBackend(QQmlEngine *, QJSEngine *) { return backend; }

int main(int argc, char *argv[]) {
    // enable modern opengl
    QSurfaceFormat fmt;
    fmt.setVersion(3, 3);
    fmt.setProfile(QSurfaceFormat::CoreProfile);
    QSurfaceFormat::setDefaultFormat(fmt);

    // initialize application
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QApplication::setApplicationName("dot");
    QApplication::setApplicationDisplayName("Dot");
    QApplication::setApplicationVersion("0.1.0");

    // initialize dir
    QString configLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QString themeLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append("/themes");
    for (const QString &location : {configLocation, themeLocation})
        if (!QDir(location).mkpath("."))
            qFatal("Could not create dir: %s", qPrintable(location));

    // parse commandline
    QCommandLineParser parser;
    parser.setApplicationDescription("Fez Dot.");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.process(app);

    // start backend
    backend = new Backend;
    QQmlApplicationEngine::setObjectOwnership(backend, QQmlEngine::CppOwnership);
    qmlRegisterSingletonType<Backend>("Backend", 1, 0, "Backend", getBackend);

    // start qml engine
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return QApplication::exec();
}
