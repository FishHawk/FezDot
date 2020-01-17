#include "backend.hpp"

#include <QApplication>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

Backend::Backend() {
    // read all theme
    QString themeLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append("/themes");
    m_themes = QDir(themeLocation).entryList(QStringList() << "*.conf", QDir::Files);
    for (auto &theme : m_themes) {
        theme.truncate(theme.lastIndexOf(QChar('.')));
    }

    // read settings
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QSettings settings(QGuiApplication::applicationName());

    // create dot by theme
    QString theme = settings.value("theme", "default").toString();
    m_dot = new DotFramebufferObject(theme);
}