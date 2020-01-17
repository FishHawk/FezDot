#include "backend.hpp"

#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QSettings>
#include <QStandardPaths>

Backend::Backend() {
    m_dot = new DotFramebufferObject();

    // read all theme
    QString themeLocation = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append("/themes");
    m_themes = QDir(themeLocation).entryList(QStringList() << "*.conf", QDir::Files);
    for (auto &theme : m_themes)
        theme.truncate(theme.lastIndexOf(QChar('.')));
    if (!m_themes.contains("default"))
        m_themes.append("default");
    qDebug()<<m_themes;

    // read settings
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QSettings settings(QGuiApplication::applicationName());

    // create dot by theme
    QString theme = settings.value("theme", "default").toString();
    loadTheme(theme);
}

void Backend::saveTheme(QString theme) {
    QSettings settings("themes/" + theme);

    settings.setValue("plane", m_dot->plane());
    settings.setValue("velocity1", m_dot->velocity1());
    settings.setValue("velocity2", m_dot->velocity2());
    for (int i = 0; i < 8; ++i) {
        settings.setValue(QString("color%1").arg(i), (m_dot->colors())[i]);
    }
}

void Backend::loadTheme(QString theme) {
    if (!m_themes.contains(theme))
        theme = "default";

    QSettings settings("themes/" + theme);

    m_dot->setPlane(static_cast<DotFramebufferObject::RotatePlane>(settings.value("plane", 0).toUInt()));
    m_dot->setVelocity1(settings.value("velocity1", 0.2).toDouble());
    m_dot->setVelocity2(settings.value("velocity2", -0.3).toDouble());
    for (int i = 0; i < 8; ++i) {
        m_dot->setColors(i, settings.value(QString("color%1").arg(i), QColor::fromHslF((i % 4) * 0.25, 1.0, 0.2, 0.6)).value<QColor>());
    }
}