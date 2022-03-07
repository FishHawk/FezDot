#include "backend.hpp"

#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>

Backend::Backend(int size, int x, int y) : m_size(size), m_x(x), m_y(y) {
    m_dot = new DotFramebufferObject();

    loadThemeList();

    // read settings
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QSettings settings(QGuiApplication::applicationName());

    // create dot by theme
    QString theme = settings.value("theme", "Default").toString();
    loadTheme(theme);

    onXChanged();
    onYChanged();
    onSizeChanged();

    connect(this, &Backend::xChanged, this, &Backend::onXChanged);
    connect(this, &Backend::yChanged, this, &Backend::onYChanged);
    connect(this, &Backend::sizeChanged, this, &Backend::onSizeChanged);
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

    settings.setValue("plane", m_dot->plane());
    settings.setValue("velocity1", m_dot->velocity1());
    settings.setValue("velocity2", m_dot->velocity2());
    for (int i = 0; i < 8; ++i) {
        settings.setValue(QString("color%1").arg(i), (m_dot->colors())[i]);
    }
    settings.sync();

    loadThemeList();
}

void Backend::loadTheme(QString theme) {
    QSettings settings("themes/" + theme);

    m_dot->setPlane(static_cast<DotFramebufferObject::RotatePlane>(settings.value("plane", 0).toUInt()));
    m_dot->setVelocity1(settings.value("velocity1", 0.2).toDouble());
    m_dot->setVelocity2(settings.value("velocity2", -0.3).toDouble());
    for (int i = 0; i < 8; ++i) {
        m_dot->setColors(i, settings.value(QString("color%1").arg(i), QColor::fromHslF((i % 4) * 0.25, 1.0, 0.2, 0.6)).value<QColor>());
    }

    loadThemeList();
}

void Backend::deleteTheme(QString theme) {
    auto filepath = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation).append(QString("/themes/%1.conf").arg(theme));
    auto file = QFile(filepath);
    file.remove();

    loadThemeList();
}