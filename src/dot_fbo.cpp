#include <QGuiApplication>
#include <QSettings>
#include <QStandardPaths>

#include "dot_fbo.hpp"
#include "dot_render.hpp"

QQuickFramebufferObject::Renderer *DotFramebufferObject::createRenderer() const {
    return new DotRender();
}

DotFramebufferObject::DotFramebufferObject() : m_colors(8) {
}