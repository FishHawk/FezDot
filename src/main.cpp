#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include <QCommandLineParser>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>

#include "dot_fbo.hpp"


static DotFramebufferObject *dot;

static QObject *getDot(QQmlEngine *, QJSEngine *) { return dot; }

int main(int argc, char *argv[]) {
    // Enable modern opengl
    QSurfaceFormat fmt;
    fmt.setVersion(3, 3);
    fmt.setProfile(QSurfaceFormat::CoreProfile);
    QSurfaceFormat::setDefaultFormat(fmt);

    // Initialize application
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("dot");
    QGuiApplication::setApplicationDisplayName("Dot");
    QGuiApplication::setApplicationVersion("1.0");
//    QString icon = XDG::IconLookup::iconPath("albert");
//    if ( icon.isEmpty() ) icon = ":app_icon";
//    app.setWindowIcon(QIcon(icon));

    // Parse commandline
    QCommandLineParser parser;
    parser.setApplicationDescription("Fez Dot.");
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addOption(QCommandLineOption({"e", "edit"}, "Edit dot style."));
    parser.process(app);

    // Read setting
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QSettings settings(QGuiApplication::applicationName());

    // Set dot fbo
    dot = new DotFramebufferObject;

    dot->setPlane(static_cast<DotFramebufferObject::RotatePlane>(settings.value("plane", 0).toUInt()));
    dot->setVelocity1(settings.value("velocity1", 0.2).toDouble());
    dot->setVelocity2(settings.value("velocity2", -0.3).toDouble());

    for (int i = 0; i < 8; ++i) {
        dot->setColors(i, settings.value(QString("color%1").arg(i),
                QColor::fromHslF((i % 4) * 0.25, 1.0, 0.2, 0.6)).value<QColor>());
    }

    // Expose c++ to qml
    QQmlApplicationEngine::setObjectOwnership(dot, QQmlEngine::CppOwnership);
    qmlRegisterSingletonType<DotFramebufferObject>("Backend", 1, 0, "Dot", getDot);

    // Start qml engine
    QQmlApplicationEngine engine;
    if (parser.isSet("edit")) {
        engine.load(QUrl(QStringLiteral("qrc:/EditWindow.qml")));
    } else {
        engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));
    }
    if (engine.rootObjects().isEmpty())
        return -1;

    return QGuiApplication::exec();
}
