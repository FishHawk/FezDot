#include <QGuiApplication>
#include <QSettings>
#include <QStandardPaths>

#include "dot_fbo.hpp"
#include "dot_render.hpp"

QQuickFramebufferObject::Renderer *DotFramebufferObject::createRenderer() const {
    return new DotRender();
}

DotFramebufferObject::DotFramebufferObject() : m_colors(8) {
    connect(this, &DotFramebufferObject::planeChanged, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::velocity1Changed, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::velocity2Changed, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::opacityChanged, this, &QQuickItem::update);
    connect(this, &DotFramebufferObject::colorsChanged, this, &QQuickItem::update);
}