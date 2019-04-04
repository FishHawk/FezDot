//
// Created by wh on 3/2/19.
//

#include <QGuiApplication>
#include <QSettings>
#include <QStandardPaths>

#include "dot_fbo.hpp"
#include "dot_render.hpp"

QQuickFramebufferObject::Renderer *DotFramebufferObject::createRenderer() const {
    return new DotRender();
}

DotFramebufferObject::DotFramebufferObject() : m_colors(8) {
    m_plane = XY;
    m_velocity1 = 0.0;
    m_velocity2 = 0.0;

    for (auto &color:m_colors) {
        color = QColor(20, 20, 20, 160);
    }
    update();
}

void DotFramebufferObject::saveChange() {
    QSettings::setPath(QSettings::defaultFormat(), QSettings::UserScope,
                       QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
    QSettings settings(QGuiApplication::applicationName());

    settings.setValue("plane", m_plane);
    settings.setValue("velocity1", m_velocity1);
    settings.setValue("velocity2", m_velocity2);

    for (int i = 0; i < 8; ++i) {
        settings.setValue(QString("color%1").arg(i), m_colors[i]);
    }
}

//void DotFramebufferObject::calColors() {
////    for (int i = 0; i < 8; ++i) {
////        m_colors[i].setHslF(i / 8.0, m_saturation, m_lightness, m_alpha);
////    }
//
//    for (int i = 0; i < 4; ++i) {
//        m_colors[2 * i].setHslF(i / 4.0, m_saturation, m_lightness, m_alpha);
//        m_colors[2 * i + 1].setHslF((i + 0.5) / 4.0, m_saturation * 0.6, m_lightness, m_alpha);
//    }
//}
