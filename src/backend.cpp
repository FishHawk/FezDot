#include "backend.hpp"

#include <QtCore/QDir>
#include <QtCore/QStandardPaths>
#include <QtGui/QScreen>
#include <QtWidgets/QApplication>

uint getIntOption(
    const QCommandLineParser &parser,
    QSettings &settings,
    const QString &name,
    uint defaultValue) {

    bool ok;
    uint value;
    if (parser.isSet(name)) {
        value = parser.value(name).toInt(&ok);
        settings.setValue(name, value);
    } else {
        value = settings.value(name, defaultValue).toInt(&ok);
    }
    if (!ok) {
        qInfo() << "Illegal argument: " << name;
        exit(EXIT_FAILURE);
    }
    return value;
}

QString getStringOption(
    const QCommandLineParser &parser,
    QSettings &settings,
    const QString &name,
    QString defaultValue) {

    QString value;
    if (parser.isSet(name)) {
        value = parser.value(name);
        settings.setValue(name, value);
    } else {
        value = settings.value(name, defaultValue).toString();
    }
    return value;
}

Backend::Backend(const QCommandLineParser &parser) {
    m_size = getIntOption(parser, m_settings, "size", 300u);
    auto screenSize = QApplication::primaryScreen()->size();
    m_x = getIntOption(parser, m_settings, "x", (screenSize.width() - m_size) / 2);
    m_y = getIntOption(parser, m_settings, "y", (screenSize.height() - m_size) / 2);
    m_layer = static_cast<WindowLayer>(getIntOption(parser, m_settings, "layer", 0));

    m_theme = getStringOption(parser, m_settings, "theme", "Default");
    loadTheme(m_theme);

    loadThemeList();

    connect(this, &Backend::xChanged, this, &Backend::onXChanged);
    connect(this, &Backend::yChanged, this, &Backend::onYChanged);
    connect(this, &Backend::sizeChanged, this, &Backend::onSizeChanged);
    connect(this, &Backend::layerChanged, this, &Backend::onLayerChanged);
    connect(this, &Backend::themeChanged, this, &Backend::onThemeChanged);
}

void Backend::loadThemeList() {
    QString themeLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append("/themes");
    m_themes = QDir(themeLocation).entryList(QStringList() << "*.conf", QDir::Files);
    for (auto &theme : m_themes)
        theme.truncate(theme.lastIndexOf(QChar('.')));
    if (!m_themes.contains("Default"))
        m_themes.append("Default");
    themesChanged();
}

void Backend::saveTheme(QString theme) {
    QSettings settings("themes/" + theme);
    m_dot->saveTheme(settings);
    loadThemeList();
}

void Backend::loadTheme(QString theme) {
    QSettings settings("themes/" + theme);
    m_dot->loadTheme(settings);
}

void Backend::deleteTheme(QString theme) {
    auto filepath = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append(QString("/themes/%1.conf").arg(theme));
    auto file = QFile(filepath);
    file.remove();
    loadThemeList();
}