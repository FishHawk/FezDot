#include <QGuiApplication>
#include <QSettings>
#include <QStandardPaths>

#include "dot_fbo.hpp"
#include "dot_render.hpp"

QQuickFramebufferObject::Renderer *DotFramebufferObject::createRenderer() const {
    return new DotRender();
}

DotFramebufferObject::DotFramebufferObject(QString theme) : m_colors(8) {
    loadThemes(theme);
    update();
}

void DotFramebufferObject::saveThemes(QString theme) {
    QSettings settings("themes/" + theme);

    settings.setValue("plane", m_plane);
    settings.setValue("velocity1", m_velocity1);
    settings.setValue("velocity2", m_velocity2);
    for (int i = 0; i < 8; ++i) {
        settings.setValue(QString("color%1").arg(i), m_colors[i]);
    }
}

void DotFramebufferObject::loadThemes(QString theme) {
    QSettings settings("themes/" + theme);

    m_plane = static_cast<DotFramebufferObject::RotatePlane>(settings.value("plane", 0).toUInt());
    m_velocity1 = settings.value("velocity1", 0.2).toDouble();
    m_velocity2 = settings.value("velocity2", -0.3).toDouble();
    for (int i = 0; i < 8; ++i) {
        setColors(i, settings.value(QString("color%1").arg(i), QColor::fromHslF((i % 4) * 0.25, 1.0, 0.2, 0.6)).value<QColor>());
    }
}
