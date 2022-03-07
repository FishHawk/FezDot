#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include <QCommandLineParser>
#include <QDir>
#include <QScreen>
#include <QStandardPaths>

#include "backend.hpp"

static Backend *backend;
static QObject *getBackend(QQmlEngine *, QJSEngine *) { return backend; }

uint getIntOption(
    const QCommandLineParser &parser,
    const QSettings &settings,
    const QString &name,
    uint defaultValue) {

    bool ok;
    uint value;
    if (parser.isSet(name)) {
        value = parser.value(name).toInt(&ok);
    } else {
        value = settings.value(name, defaultValue).toInt(&ok);
    }
    if (!ok) {
        qInfo() << "Illegal argument: " << name;
        exit(EXIT_FAILURE);
    }
    return value;
}

std::tuple<uint, uint, uint> parseCommandLine(const QApplication &app) {
    QCommandLineParser parser;
    parser.setApplicationDescription("A rotating translucent four dimensions hypercube.");
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
    });
    parser.addHelpOption();
    parser.addVersionOption();
    parser.process(app);

    QSettings settings{"settings"};
    auto size = getIntOption(parser, settings, "size", 300u);
    auto screenSize = app.primaryScreen()->size();
    auto x = getIntOption(parser, settings, "x", (screenSize.width() - size) / 2);
    auto y = getIntOption(parser, settings, "y", (screenSize.height() - size) / 2);

    return {size, x, y};
}

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
    auto [size, x, y] = parseCommandLine(app);

    // start backend
    backend = new Backend(size, x, y);
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
