#include <QGuiApplication>
#include <QSettings>
#include <QStandardPaths>

#include "dot_fbo.hpp"
#include "dot_render.hpp"

DotFramebufferObject::DotFramebufferObject() : m_colors(8) {
    connect(this, &DotFramebufferObject::planeChanged, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::velocity1Changed, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::velocity2Changed, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::opacityChanged, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::colorsChanged, this, &QQuickItem::update);
}

QQuickFramebufferObject::Renderer *DotFramebufferObject::createRenderer() const {
    return new DotRender();
}

void DotFramebufferObject::loadTheme(const QSettings &theme) {
    m_plane = static_cast<DotFramebufferObject::RotatePlane>(theme.value("plane", 0).toUInt());
    m_velocity1 = theme.value("velocity1", 0.2).toDouble();
    m_velocity2 = theme.value("velocity2", -0.3).toDouble();
    m_opacity = theme.value("opacity", 0.6).toDouble();
    for (int i = 0; i < 8; ++i) {
        m_colors[i] = theme.value(QString("color%1").arg(i), QColor::fromHslF((i % 4) * 0.25, 1.0, 0.2, 0.6)).value<QColor>();
    }
}

void DotFramebufferObject::saveTheme(QSettings &theme) {
    theme.setValue("plane", m_plane);
    theme.setValue("velocity1", m_velocity1);
    theme.setValue("velocity2", m_velocity2);
    theme.setValue("opacity", m_opacity);
    for (int i = 0; i < 8; ++i) {
        theme.setValue(QString("color%1").arg(i), m_colors[i]);
    }
    theme.sync();
}
