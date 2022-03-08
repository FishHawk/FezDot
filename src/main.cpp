#include <QtCore/QCommandLineParser>
#include <QtCore/QDir>
#include <QtCore/QStandardPaths>
#include <QtQml/QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include <QtWidgets/QApplication>

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
    QApplication::setApplicationName("fez-dot");
    QApplication::setApplicationDisplayName("Fez Dot");
    QApplication::setApplicationVersion("0.1.1");

    // initialize dir
    QString configLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QString themeLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append("/themes");
    for (const QString &location : {configLocation, themeLocation})
        if (!QDir(location).mkpath("."))
            qFatal("Could not create dir: %s", qPrintable(location));

    // set config path
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));

    // parse commandline
    QCommandLineParser parser;
    parser.setApplicationDescription("A rotating translucent four dimensions tesseract.");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addOptions({
        {"size",
         QCoreApplication::translate("main", "Set window size."),
         QCoreApplication::translate("main", "size")},
        {"x",
         QCoreApplication::translate("main", "Set window position x."),
         QCoreApplication::translate("main", "position-x")},
        {"y",
         QCoreApplication::translate("main", "Set window position y."),
         QCoreApplication::translate("main", "position-y")},
        {"layer",
         QCoreApplication::translate("main", "Set window layer. 0:Above others, 1:Below others, 2:Normal."),
         QCoreApplication::translate("main", "layer")},
        {"theme",
         QCoreApplication::translate("main", "Set dot theme."),
         QCoreApplication::translate("main", "theme")},
    });
    parser.process(app);

    // start backend
    backend = new Backend(parser);
    QQmlApplicationEngine::setObjectOwnership(backend, QQmlEngine::CppOwnership);
    qmlRegisterSingletonType<Backend>("Backend", 1, 0, "Backend", getBackend);
    qmlRegisterType<DotFramebufferObject>("Backend", 1, 0, "Dot");

    // start qml engine
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));
    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    return QApplication::exec();
}
